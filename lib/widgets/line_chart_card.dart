import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartCard extends StatelessWidget {
  final List<FlSpot> spots;

  const LineChartCard({super.key, required this.spots});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 2.5,
            color: Colors.blue,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        minX: spots.isNotEmpty ? spots.last.x : 0, // Start from the last X value
        maxX: spots.isNotEmpty ? spots.first.x : 24, // End at the first X value
        minY: 0, // Minimum Y value
        maxY: 100, // Maximum Y value
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (spots.isNotEmpty ? (spots.first.x - spots.last.x) / 5 : 1), // Dynamic interval
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                final formattedTime = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                return Text(
                  formattedTime,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              interval: 10,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(enabled: true), // Enable touch interactions
      ),
    );
  }
}