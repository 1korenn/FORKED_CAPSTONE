import 'package:flutter/material.dart';
import 'package:capstone_project/services/firebase_service.dart';
import 'package:capstone_project/widgets/ph_chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class PhGraphScreen extends StatefulWidget {
  @override
  _PhGraphScreenState createState() => _PhGraphScreenState();
}

class _PhGraphScreenState extends State<PhGraphScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final List<FlSpot> _phSpots = [];
  final List<FlSpot> _historySpots = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromLocalStorage();
    _loadDataFromFirebase();
    _listenToPhStream();
  }

  Future<void> _loadDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('phSpots');
    if (savedData != null) {
      final List<dynamic> decodedData = jsonDecode(savedData);
      setState(() {
        for (var item in decodedData) {
          final spot = FlSpot(item['x'], item['y']);
          if (!_phSpots.contains(spot)) {
            _phSpots.add(spot);
          }
        }
      });
    }
  }

  Future<void> _saveDataToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(
      _phSpots.map((spot) => {'x': spot.x, 'y': spot.y}).toList(),
    );
    await prefs.setString('phSpots', encodedData);
  }

  void _listenToPhStream() {
    _firebaseService.getPhStream().listen((value) {
      if (value.isEmpty) return;

      final phValue = double.tryParse(value) ?? 0.0;
      if (phValue < 0 || phValue > 14) return;

      final timestamp = DateTime.now().millisecondsSinceEpoch.toDouble();

      setState(() {
        if (_phSpots.isEmpty || _phSpots.last.x != -timestamp) {
          _phSpots.add(FlSpot(-timestamp, phValue)); // Reverse X-axis by negating timestamp

          if (_phSpots.length > 144) {
            _phSpots.removeAt(0);
          }

          _phSpots.sort((a, b) => b.x.compareTo(a.x)); // Sort in descending order for right-to-left
          _phSpots.removeWhere((spot) =>
              _phSpots.indexOf(spot) !=
              _phSpots.lastIndexWhere((s) => s.x == spot.x));

          _saveDataToLocalStorage();
          _saveDataToFirebase(); // Ensure data is saved to Firebase
        }
      });
    });
  }

  Future<void> _saveDataToFirebase() async {
    final databaseRef = FirebaseDatabase.instance.ref('phData');
    final phData = _phSpots.map((spot) => {'x': -spot.x, 'y': spot.y}).toList(); // Reverse X-axis back
    final historyData = _historySpots.map((spot) => {'x': -spot.x, 'y': spot.y}).toList(); // Reverse X-axis back

    await databaseRef.update({
      'current': phData,
      'history': historyData,
    });
  }

  Future<void> _loadDataFromFirebase() async {
    final databaseRef = FirebaseDatabase.instance.ref('phData');
    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      try {
        final data = snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          final currentData = data['current'] as List<dynamic>? ?? [];
          final historyData = data['history'] as List<dynamic>? ?? [];

          _phSpots.clear();
          _historySpots.clear();

          _phSpots.addAll(currentData.map((item) {
            final x = item['x'] as num? ?? 0;
            final y = item['y'] as num? ?? 0;
            return FlSpot(-x.toDouble(), y.toDouble()); // Reverse X-axis
          }));

          _historySpots.addAll(historyData.map((item) {
            final x = item['x'] as num? ?? 0;
            final y = item['y'] as num? ?? 0;
            return FlSpot(-x.toDouble(), y.toDouble()); // Reverse X-axis
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

  void _showHistory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('PH History'),
          content: SizedBox(
            height: 300,
            child: _historySpots.isNotEmpty
                ? ListView.builder(
                    itemCount: _historySpots.length,
                    itemBuilder: (context, index) {
                      final spot = _historySpots[index];
                      final date = DateTime.fromMillisecondsSinceEpoch(
                          (-spot.x).toInt()); // Reverse X-axis back
                      final formattedTime =
                          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                      return ListTile(
                        title: Text(
                          'PH: ${spot.y.toStringAsFixed(2)} at $formattedTime',
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No history data available.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

    @override
      Widget build(BuildContext context) {
        // Filter spots to include only one point per 10-minute interval
        final filteredSpots = _phSpots.where((spot) {
          final timestamp = DateTime.fromMillisecondsSinceEpoch((-spot.x).toInt());
          return timestamp.minute % 10 == 0 && timestamp.second == 0;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('PH Graph'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _showHistory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _phSpots.isEmpty
            ? Center(
                child: Text(
                  'No data available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : PhChartCard(spots: filteredSpots),
      ),
    );
  }
}