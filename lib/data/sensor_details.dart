import 'package:capstone_project/model/health_model.dart';
import 'package:capstone_project/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensorDetails {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<HealthModel>> getSensorData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load cached values
    final cachedPh = prefs.getString('cachedPh') ?? 'Loading...';
    final cachedMoisture = prefs.getString('cachedMoisture') ?? 'Loading...';

    // Return cached values immediately
    final initialData = [
      HealthModel(
        icon: 'assets/icons/burn.png',
        value: cachedPh,
        title: "PH Level",
      ),
      HealthModel(
        icon: 'assets/icons/steps.png',
        value: cachedMoisture,
        title: "Moisture",
      ),
      HealthModel(
        icon: 'assets/icons/distance.png',
        value: "test", // Replace with actual value if needed
        title: "Heat",
      ),
    ];

    // Fetch data in the background
    try {
      final results = await Future.wait([
        _firebaseService.getCurrentPh(),
        _firebaseService.getCurrentMoisture(),
      ]);

      final phValue = results[0];
      final moistureValue = results[1];

      // Save to cache
      prefs.setString('cachedPh', phValue);
      prefs.setString('cachedMoisture', moistureValue);

      return [
        HealthModel(
          icon: 'assets/icons/burn.png',
          value: phValue,
          title: "PH Level",
        ),
        HealthModel(
          icon: 'assets/icons/steps.png',
          value: moistureValue,
          title: "Moisture",
        ),
        HealthModel(
          icon: 'assets/icons/distance.png',
          value: "test", // Replace with actual value if needed
          title: "Heat",
        ),
      ];
    } catch (e) {
      print('Error fetching sensor data: $e');
      return initialData; // Return cached values in case of error
    }
  }
}