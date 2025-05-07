import 'package:flutter/material.dart';
import 'package:capstone_project/services/firebase_service.dart';
import 'package:capstone_project/widgets/line_chart_card.dart';
import 'package:fl_chart/fl_chart.dart';


class PhGraphScreen extends StatefulWidget {
  @override
  _PhGraphScreenState createState() => _PhGraphScreenState();
}

class _PhGraphScreenState extends State<PhGraphScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final List<FlSpot> _phSpots = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            Expanded(
              child: _phSpots.isEmpty
                  ? Center(
                      child: Text(
                        "No data available",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : LineChartCard(spots: _phSpots),
            ),
          ],
        ),
      ),
    );
  }
}