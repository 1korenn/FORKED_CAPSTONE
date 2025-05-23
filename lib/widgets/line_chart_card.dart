import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartCard extends StatelessWidget {
  final List<FlSpot> spots;

  const LineChartCard({super.key, required this.spots});

  @override
  Widget build(BuildContext context) {
    final displaySpots = spots.toList()..sort((a, b) => a.x.compareTo(b.x));

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: displaySpots.map((spot) => FlSpot(-spot.x, spot.y)).toList(),
            barWidth: 2.5,
            color: Colors.blue,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ],
        minX: displaySpots.isNotEmpty ? -displaySpots.last.x : 0,
        maxX: displaySpots.isNotEmpty ? -displaySpots.first.x : 24,
        minY: 0,
        maxY: 100,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: displaySpots.length > 1
                  ? ((displaySpots.last.x - displaySpots.first.x).abs() / 5).clamp(1, double.infinity)
                  : 1,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(-value.toInt());
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
