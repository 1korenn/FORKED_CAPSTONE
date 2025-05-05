import 'package:capstone_project/screens/heat_graph.dart';
import 'package:capstone_project/screens/moisture_graph.dart';
import 'package:capstone_project/screens/ph_graph.dart';

import 'package:flutter/material.dart';

class GraphScreen extends StatefulWidget {
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  int _selectedIndex = 0; 

  @override
  Widget build(BuildContext context) {
    Widget _renderedWidget;

    switch (_selectedIndex) {
      case 0: // Test1 Chart
        _renderedWidget = SizedBox.shrink(); // Render a placeholder widget
        break;
      case 1: // PH Chart
        _renderedWidget = PhGraphScreen(); // Render the PH graph screen
        break;
      case 2: // Moisture Chart
        _renderedWidget = MoistureGraphScreen(); // Render the Moisture graph screen
        break;
      case 3: // Heat Chart
        _renderedWidget = HeatGraphScreen(); // Render the Heat graph screen
        break;
      default:
        _renderedWidget = SizedBox.shrink(); // Render nothing
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Test1 Graph Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: _renderedWidget,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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