
// import 'package:fitness_dashboard_ui/widgets/pie_chart_widget.dart';


import 'package:capstone_project/const/constant.dart';
import 'package:capstone_project/widgets/scheduled_widget.dart';
import 'package:capstone_project/widgets/summary_details.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/widgets/sensor_summary_widget.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: cardBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            // Chart(), 
            Text(
              'Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
               color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            SummaryDetails(),
            SizedBox(height: 16),
            SensorSummaryStreamWidget(), //this is problematic
            SizedBox(height: 40),
            Scheduled(),
          ],
        ),
      ),
    );
  }
}
