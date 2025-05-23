import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PhChartCard extends StatelessWidget {
  final List<FlSpot> spots;

  const PhChartCard({super.key, required this.spots});

  @override
  Widget build(BuildContext context) {
    // Filter out duplicate consecutive values
    final displaySpots = spots.toList()
      ..sort((a, b) => a.x.compareTo(b.x))
      ..removeWhere((spot) {
        final index = spots.indexOf(spot);
        if (index > 0) {
          return spots[index].y == spots[index - 1].y; // Remove if same as previous value
        }
        return false;
      });

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: displaySpots.map((spot) => FlSpot(-spot.x, spot.y)).toList(), // Reverse X-axis
            barWidth: 2.5, // Match the line thickness
            color: Colors.blue, // Match the line color
            belowBarData: BarAreaData(show: false), // Disable shaded area
            dotData: FlDotData(show: true), // Enable dots
          ),
        ],
        minX: displaySpots.isNotEmpty ? -displaySpots.last.x : 0,
        maxX: displaySpots.isNotEmpty ? -displaySpots.first.x : 24,
        minY: 0,
        maxY: 14,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: displaySpots.length > 1
                  ? ((displaySpots.last.x - displaySpots.first.x).abs() / 5).clamp(1, double.infinity)
                  : 1,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(-value.toInt()).toLocal(); // Convert to local timezone
                final formattedTime =
                    "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
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
              interval: 2,
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
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots
                .map(
                  (spot) => LineTooltipItem(
                    '${spot.y}',
                    TextStyle(color: Colors.white),
                  ),
                )
                .toList(), 
          ),
        ),
      ),
    );
  }
}