import 'package:flutter/material.dart';
import 'package:capstone_project/services/firebase_service.dart';
import 'package:capstone_project/widgets/line_chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart'; // Import added

class MoistureGraphScreen extends StatefulWidget {
  @override
  _MoistureGraphScreenState createState() => _MoistureGraphScreenState();
}

class _MoistureGraphScreenState extends State<MoistureGraphScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final List<FlSpot> _moistureSpots = [];
  final List<FlSpot> _historySpots = []; // To store historical data

  @override
  void initState() {
    super.initState();
    _loadDataFromFirebase(); // Load data from Firebase
    _listenToMoistureStream(); // Listen for real-time updates
  }

  // Listen for real-time updates
  void _listenToMoistureStream() {
    _firebaseService.getMoistureStream().listen((value) {
      setState(() {
        final moistureValue = double.tryParse(value) ?? 0.0;
        final timestamp = DateTime.now().millisecondsSinceEpoch.toDouble(); // Use timestamp as X-axis
        _moistureSpots.add(FlSpot(timestamp, moistureValue));

        // Save the new data to local storage
        _saveDataToFirebase();

        // Limit the number of points to 144 (24 hours with 10-minute intervals)
        if (_moistureSpots.length > 144) {
          _historySpots.add(_moistureSpots.removeAt(0)); // Move removed data to history
        }
      });
    });
  }

  // Save data to local storage
  Future<void> _saveDataToFirebase() async {
  final databaseRef = FirebaseDatabase.instance.ref('moistureData');
  final moistureData = _moistureSpots.map((spot) => {'x': spot.x, 'y': spot.y}).toList();
  final historyData = _historySpots.map((spot) => {'x': spot.x, 'y': spot.y}).toList();

  await databaseRef.set({
    'current': moistureData,
    'history': historyData,
  });
}


  // Load data from local storage
  Future<void> _loadDataFromFirebase() async {
  final databaseRef = FirebaseDatabase.instance.ref('moistureData');
  final snapshot = await databaseRef.get();

  if (snapshot.exists) {
    final data = snapshot.value as Map;
    final currentData = data['current'] as List<dynamic>;
    final historyData = data['history'] as List<dynamic>;

    _moistureSpots.addAll(currentData.map((item) => FlSpot(item['x'], item['y'])));
    _historySpots.addAll(historyData.map((item) => FlSpot(item['x'], item['y'])));
  }

  setState(() {}); // Refresh the UI
}
  // Show historical data
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
                final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Moisture Graph'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _showHistory, // Show historical data
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: LineChartCard(spots: _moistureSpots), // Pass the updated spots
            ),
          ],
        ),
      ),
    );
  }
}