import 'package:flutter/material.dart';
import 'package:capstone_project/services/firebase_service.dart';
import 'package:capstone_project/widgets/line_chart_card.dart';
import 'package:fl_chart/fl_chart.dart';

class MoistureGraphScreen extends StatefulWidget {
  @override
  _MoistureGraphScreenState createState() => _MoistureGraphScreenState();
}

class _MoistureGraphScreenState extends State<MoistureGraphScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final List<FlSpot> _moistureSpots = [];

  @override
  void initState() {
    super.initState();

    // Listen for changes in moisture
    _firebaseService.getMoistureStream().listen((value) {
      setState(() {
        final moistureValue = double.tryParse(value) ?? 0.0;
        final timestamp = DateTime.now().millisecondsSinceEpoch.toDouble(); // Use timestamp as X-axis
        _moistureSpots.add(FlSpot(timestamp, moistureValue));

        // Limit the number of points to 24 hours
        if (_moistureSpots.length > 144) {
          _moistureSpots.removeAt(0);
        }

        // Debugging: Print the spots
        print("Moisture Value: $moistureValue, Spots: $_moistureSpots");
      });
    });
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
              child: LineChartCard(spots: _moistureSpots), // Wrap in Expanded
            ),
          ],
        ),
      ),
    );
  }
}