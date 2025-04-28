import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  String _moisture = 'Loading...';
  String _ph = 'Loading...';

 

  @override
  void initState() {
    super.initState();

    // Listen for changes in moisture
    _firebaseService.getMoistureStream().listen((value) {
      setState(() {
        _moisture = value;
      });
    });

    // Listen for changes in pH
    _firebaseService.getPhStream().listen((value) {
      setState(() {
        _ph = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🌱 Soil Moisture: $_moisture',
              style: TextStyle(
                fontSize: 22,
                color: Colors.green, // Added green color for soil moisture
              ),
            ),
            SizedBox(height: 10),
            Text(
              '🧪 Soil pH Level: $_ph',
              style: TextStyle(
                fontSize: 22,
                color: Colors.blue, // Added blue color for soil pH level
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
