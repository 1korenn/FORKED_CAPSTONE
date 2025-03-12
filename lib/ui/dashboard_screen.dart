import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center( // Wrap the main container in a Center widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  Text('PH Level'),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Text('Moisture'),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Text('Heat'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}