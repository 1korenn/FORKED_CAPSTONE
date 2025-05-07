import 'package:capstone_project/util/responsive.dart';
import 'package:capstone_project/widgets/activity_details_card.dart';
import 'package:capstone_project/widgets/bar_graph_widget.dart';
import 'package:capstone_project/widgets/header_widget.dart';
import 'package:capstone_project/widgets/summary_widget.dart';
import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Align items to the center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Align items to the center horizontally
          children: [
            const SizedBox(height: 30),
            const HeaderWidget(),
            const SizedBox(height: 240),
            const ActivityDetailsCard(),
            const SizedBox(height: 18),
            const BarGraphCard(),
            const SizedBox(height: 50),
            if (Responsive.isTablet(context)) const SummaryWidget(),
          ],
        ),
      ),
    );
  }
}