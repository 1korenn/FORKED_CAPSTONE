import 'package:capstone_project/widgets/custom_card_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartCard extends StatelessWidget {
  final List<FlSpot> spots; // Accept spots as a parameter

  const LineChartCard({super.key, required this.spots});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Center( // Center the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Moisture Level",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded( // Wrap the LineChart in Expanded to prevent overflow
              child: AspectRatio(
                aspectRatio: 16 / 6,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots, // Use the passed spots parameter
                        isCurved: true,
                        barWidth: 2.5,
                        color: Colors.blue,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    minX: spots.isNotEmpty ? spots.first.x : 0,
                    maxX: spots.isNotEmpty ? spots.last.x : 24,
                    minY: 0,
                    maxY: 100, // Adjust based on your moisture value range
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 3600000, // Show titles every hour (3600000 ms = 1 hour)
                          getTitlesWidget: (value, meta) {
                            // Convert timestamp to readable time
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}