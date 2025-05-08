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
    final screenWidth = MediaQuery.of(context).size.width;

    Widget _renderedWidget;

    switch (_selectedIndex) {
      case 0:
        _renderedWidget = PhGraphScreen();
        break;
      case 1:
        _renderedWidget = MoistureGraphScreen();
        break;
      case 2:
        _renderedWidget = HeatGraphScreen();
        break;
      default:
        _renderedWidget = Center(
          child: Text(
            'No Graph Selected',
            style: TextStyle(fontSize: screenWidth * 0.05),
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Graph Screen',
          // style: TextStyle(fontSize: screenWidth * 0.02),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: _renderedWidget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'PH Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water),
            label: 'Moisture Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Heat Graph',
          ),
        ],
      ),
    );
  }
}