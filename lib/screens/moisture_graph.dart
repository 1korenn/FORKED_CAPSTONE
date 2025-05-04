import 'package:flutter/material.dart';
import 'package:capstone_project/services/firebase_service.dart';
import 'package:capstone_project/widgets/line_chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MoistureGraphScreen extends StatefulWidget {
  @override
  _MoistureGraphScreenState createState() => _MoistureGraphScreenState();
}

class _MoistureGraphScreenState extends State<MoistureGraphScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final List<FlSpot> _moistureSpots = [];
  final List<FlSpot> _historySpots = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromLocalStorage(); // Load data from local storage
    _loadDataFromFirebase(); // Load data from Firebase
    _listenToMoistureStream(); // Listen for real-time updates
  }

  // Load data from local storage
  Future<void> _loadDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('moistureSpots');
    if (savedData != null) {
      final List<dynamic> decodedData = jsonDecode(savedData);
      setState(() {
        for (var item in decodedData) {
          final spot = FlSpot(item['x'], item['y']);
          if (!_moistureSpots.contains(spot)) {
            _moistureSpots.add(spot);
          }
        }
      });
    }
  }

  // Save data to local storage
  Future<void> _saveDataToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(_moistureSpots.map((spot) => {'x': spot.x, 'y': spot.y}).toList());
    await prefs.setString('moistureSpots', encodedData);
  }

  // Listen for real-time updates
  void _listenToMoistureStream() {
    _firebaseService.getMoistureStream().listen((value) {
      if (value.isEmpty) return;

      setState(() {
        final moistureValue = double.tryParse(value) ?? 0.0;
        if (moistureValue < 0 || moistureValue > 100) return;

        final timestamp = DateTime.now().millisecondsSinceEpoch.toDouble();

        // Prevent duplicates by checking if the timestamp already exists
        if (_moistureSpots.isEmpty || _moistureSpots.last.x != timestamp) {
          _moistureSpots.add(FlSpot(timestamp, moistureValue));

          if (_moistureSpots.length > 144) {
            _moistureSpots.removeAt(0); // Remove the oldest point
          }
        }

        // Sort the spots by x value to ensure correct rendering
        _moistureSpots.sort((a, b) => a.x.compareTo(b.x));

        // Remove any duplicates that might exist after sorting
        _moistureSpots.removeWhere((spot) =>
            _moistureSpots.indexOf(spot) !=
            _moistureSpots.lastIndexWhere((s) => s.x == spot.x));

        _saveDataToLocalStorage(); // Save updated data to local storage
      });
    });
  }

  // Load data from Firebase
  Future<void> _loadDataFromFirebase() async {
    try {
      final data = await _firebaseService.getCurrentMoisture();
      if (data != null) {
        setState(() {
          final moistureValue = double.tryParse(data) ?? 0.0;
          final timestamp = DateTime.now().millisecondsSinceEpoch.toDouble();

          // Prevent duplicates by checking if the timestamp already exists
          if (_moistureSpots.isEmpty || _moistureSpots.last.x != timestamp) {
            _moistureSpots.add(FlSpot(timestamp, moistureValue));
          }

          // Sort the spots by x value to ensure correct rendering
          _moistureSpots.sort((a, b) => a.x.compareTo(b.x));

          // Remove any duplicates that might exist after sorting
          _moistureSpots.removeWhere((spot) =>
              _moistureSpots.indexOf(spot) !=
              _moistureSpots.lastIndexWhere((s) => s.x == spot.x));

          _saveDataToLocalStorage(); // Save updated data to local storage
        });
      }
    } catch (e) {
      print('Error loading data from Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moisture Graph'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: _moistureSpots.isEmpty
                  ? Center(
                      child: Text(
                        "No data available",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : LineChartCard(spots: _moistureSpots),
            ),
          ],
        ),
      ),
    );
  }
}