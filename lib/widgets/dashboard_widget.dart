import 'package:capstone_project/util/responsive.dart';
import 'package:capstone_project/widgets/carousel_widget.dart';
import 'package:capstone_project/widgets/sensor_details_card.dart';
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
          children: [
            const SizedBox(height: 30),
            const HeaderWidget(),
            const SizedBox(height: 30),
             CarouselWidget(),
            const SizedBox(height: 20),
            Center(child: const SensorDetailsCard()),
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