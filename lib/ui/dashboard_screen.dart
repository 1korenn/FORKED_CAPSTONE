import 'package:capstone_project/screens/main_screen.dart';
import 'package:flutter/material.dart';
// Correctly import DashboardScreen
import 'package:capstone_project/styles/theme.dart'; // Import the theme

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capstone Project',
      theme: appTheme, // Apply the global theme
      home: MainScreen(), // Set DashboardScreen as the main screen
    );
  }
}