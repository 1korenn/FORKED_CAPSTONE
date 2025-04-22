import 'package:capstone_project/widgets/custom_card_widget.dart';

import 'package:flutter/material.dart';

class SummaryDetails extends StatelessWidget {
  const SummaryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Color.fromARGB(255, 26, 26, 34),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDetails('sensor value', '305'),
          buildDetails('sensor value', '10983'),
          buildDetails('sensor value', '111'),
        ],
      ),
    );
  }

  Widget buildDetails(String key, String value) {
    return Column(
      children: [
        Text(
          key,
          style: const TextStyle(fontSize: 11, color: Color.fromARGB(255, 255, 253, 253)),
        ),
        const SizedBox(height: 2),
        Text(
        value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white, // Add white color to the text
        ),
      ),
      ],
    );
  }
}
