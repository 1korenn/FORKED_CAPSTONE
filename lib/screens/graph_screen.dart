import 'package:capstone_project/data/line_chart_data.dart';
import 'package:capstone_project/widgets/line_chart_card.dart';
import 'package:flutter/material.dart';

class GraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = LineData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Test1 Graph Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: LineChartCard(spots: data.test1Spots), // Pass the dataset here
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Test1 CHART',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'PH CHART',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'MOISTURE CHART',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'HEAT CHART',
          ),
        ],
      ),
    );
  }
}