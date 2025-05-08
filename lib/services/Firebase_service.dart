import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Stream<String> getMoistureStream() {
    return _dbRef.child('sensorData/moisture').onValue.map((event) {
      final value = event.snapshot.value;
      return value != null ? value.toString() : 'Loading...';
    }); 
  }

  Stream<String> getPhStream() {
    return _dbRef.child('sensorData/ph').onValue.map((event) {
      final value = event.snapshot.value;
      return value != null ? value.toString() : 'Loading...';
    });
  }

  Future<String> getCurrentMoisture() async {
    final snapshot = await _dbRef.child('sensorData/moisture').get();
    final value = snapshot.value;
    return value != null ? value.toString() : 'Loading...';
  }

  Future<String> getCurrentPh() async {
    final snapshot = await _dbRef.child('sensorData/ph').get();
    final value = snapshot.value;
    return value != null ? value.toString() : 'Loading...';
  }
}