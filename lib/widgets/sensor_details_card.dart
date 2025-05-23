import 'package:capstone_project/data/sensor_details.dart';
import 'package:capstone_project/util/responsive.dart';
import 'package:capstone_project/widgets/custom_card_widget.dart';
import 'package:flutter/material.dart';

class SensorDetailsCard extends StatelessWidget {
  const SensorDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final sensorDetails = SensorDetails();
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        width: screenWidth * 0.9,
        child: StreamBuilder(
          stream: sensorDetails.getSensorDataStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading sensor data'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No sensor data available'));
            }

            final sensorData = snapshot.data!;

            return GridView.builder(
              itemCount: sensorData.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                crossAxisSpacing: Responsive.isMobile(context) ? 12 : 15,
                mainAxisSpacing: 12.0,
              ),
              itemBuilder: (context, index) => CustomCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      sensorData[index].icon,
                      width: 30,
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 4),
                      child: Text(
                        sensorData[index].value,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      sensorData[index].title,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
