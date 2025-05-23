import 'dart:async';
import 'package:async/async.dart';
import 'package:capstone_project/model/sensor_model.dart';
import 'package:capstone_project/services/firebase_service.dart';

class SensorDetails {
  final FirebaseService _firebaseService = FirebaseService();

  Stream<List<SensorModel>> getSensorDataStream() {
    // Combine the ph and moisture streams into a single stream
    final phStream = _firebaseService.getPhStream();
    final moistureStream = _firebaseService.getMoistureStream();

    return StreamZip([phStream, moistureStream]).map((values) {
      final phValue = values[0];
      final moistureValue = values[1];

      return [
        SensorModel(
          icon: 'assets/icons/ph.jpg',
          value: phValue.toString(),
          title: "PH Level",
        ),
        SensorModel(
          icon: 'assets/icons/moisture.jpg',
          value: moistureValue.toString(),
          title: "Moisture",
        ),
        SensorModel(
          icon: 'assets/icons/heat.jpg',
          value: "test", // Replace with actual value if needed
          title: "Heat",
        ),
        SensorModel(
          icon: 'assets/icons/weather.png',
          value: "test", // Replace with actual value if needed
          title: "weather",
        ),
      ];
    });
  }
}