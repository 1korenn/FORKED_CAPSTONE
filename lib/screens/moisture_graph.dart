import 'package:flutter/material.dart';
import 'package:capstone_project/services/firebase_service.dart';
import 'package:capstone_project/widgets/line_chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
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
    _loadDataFromLocalStorage();
    _loadDataFromFirebase();
    _listenToMoistureStream();
  }

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

  Future<void> _saveDataToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(
      _moistureSpots.map((spot) => {'x': spot.x, 'y': spot.y}).toList(),
    );
    await prefs.setString('moistureSpots', encodedData);
  }

  void _listenToMoistureStream() {
    _firebaseService.getMoistureStream().listen((value) {
      if (value.isEmpty) return;

      final moistureValue = double.tryParse(value) ?? 0.0;
      if (moistureValue < 0 || moistureValue > 100) return;

      final timestamp = DateTime.now().millisecondsSinceEpoch.toDouble();

      setState(() {
        // Check if the last value already exists to avoid duplication
        if (_moistureSpots.isEmpty || _moistureSpots.last.x != timestamp) {
          _moistureSpots.add(FlSpot(timestamp, moistureValue));

          if (_moistureSpots.length > 144) {
            _moistureSpots.removeAt(0);
          }

          _moistureSpots.sort((a, b) => a.x.compareTo(b.x));
          _moistureSpots.removeWhere((spot) =>
              _moistureSpots.indexOf(spot) !=
              _moistureSpots.lastIndexWhere((s) => s.x == spot.x));

          _saveDataToLocalStorage();
          _saveDataToFirebase(); // Ensure data is saved to Firebase
        }
      });
    });
  }

  Future<void> _loadDataFromFirebase() async {
    final databaseRef = FirebaseDatabase.instance.ref('moistureData');
    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      try {
        final data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          final currentData = data['current'] as List<dynamic>? ?? [];
          final historyData = data['history'] as List<dynamic>? ?? [];

          _moistureSpots.clear();
          _historySpots.clear();

          _moistureSpots.addAll(currentData.map((item) {
            final x = item['x'] as num? ?? 0;
            final y = item['y'] as num? ?? 0;
            return FlSpot(x.toDouble(), y.toDouble());
          }));

          _historySpots.addAll(historyData.map((item) {
            final x = item['x'] as num? ?? 0;
            final y = item['y'] as num? ?? 0;
            return FlSpot(x.toDouble(), y.toDouble());
          }));
        }
      } catch (e) {
        print('Error parsing Firebase data: $e');
      }

      setState(() {});
    } else {
      print('No data found in Firebase.');
    }
  }

  Future<void> _saveDataToFirebase() async {
    final databaseRef = FirebaseDatabase.instance.ref('moistureData');
    final moistureData =
        _moistureSpots.map((spot) => {'x': spot.x, 'y': spot.y}).toList();
    final historyData =
        _historySpots.map((spot) => {'x': spot.x, 'y': spot.y}).toList();

    await databaseRef.update({
      'current': moistureData,
      'history': historyData,
    });
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Historical Data'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _historySpots.length,
              itemBuilder: (context, index) {
                final spot = _historySpots[index];
                final date =
                    DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                return ListTile(
                  title: Text('Time: ${date.hour}:${date.minute}'),
                  subtitle: Text('Moisture: ${spot.y.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Filter spots to include only one point per 10-minute interval
    final filteredSpots = _moistureSpots.where((spot) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
      return timestamp.minute % 10 == 0 && timestamp.second == 0;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            Expanded(
              child: filteredSpots.isEmpty
                  ? Center(
                      child: Text(
                        "No data available",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : LineChartCard(spots: filteredSpots),
            ),
          ],
        ),
      ),
    );
  }
}