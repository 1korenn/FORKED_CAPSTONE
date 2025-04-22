import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  String _moisture = 'Loading...';
  String _ph = 'Loading...';

  @override
  void initState() {
    super.initState();

    // Listen for changes in moisture
    _dbRef.child('sensorData/moisture').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        setState(() {
          _moisture = value.toString();
        });
      }
    });

    // Listen for changes in pH
    _dbRef.child('sensorData/ph').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        setState(() {
          _ph = value.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test screen')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🌱 Soil Moisture: $_moisture', style: TextStyle(fontSize: 22)),
            SizedBox(height: 10),
            Text('🧪 Soil pH Level: $_ph', style: TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
