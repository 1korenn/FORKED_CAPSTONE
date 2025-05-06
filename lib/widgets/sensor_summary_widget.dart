import 'package:flutter/material.dart';
import 'package:capstone_project/services/firebase_service.dart';

class SensorSummaryStreamWidget extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  SensorSummaryStreamWidget({super.key});

  String getMoistureFeedback(double value) {
    if (value < 300) return 'Soil is too dry. Consider watering your plants.';
    if (value > 700) return 'Soil is too wet. Drainage might be needed.';
    return 'Soil moisture is optimal.';
  }

  String getPhFeedback(double value) {
    if (value < 5.5) return 'Soil is too acidic. Consider using lime.';
    if (value > 7.5) return 'Soil is too alkaline. Add sulfur or compost.';
    return 'Soil pH is within a healthy range.';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: firebaseService.getMoistureStream(),
      builder: (context, moistureSnapshot) {
        return StreamBuilder<String>(
          stream: firebaseService.getPhStream(),
          builder: (context, phSnapshot) {
            if (!moistureSnapshot.hasData || !phSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final double? moisture =
                double.tryParse(moistureSnapshot.data ?? '');
            final double? ph = double.tryParse(phSnapshot.data ?? '');

            if (moisture == null || ph == null) {
              return const Text(
                'Invalid sensor data.',
                style: TextStyle(color: Colors.red),
              );
            }

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary Report',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text('• Moisture: ${moisture.toStringAsFixed(2)} - ${getMoistureFeedback(moisture)}',
                      style: const TextStyle(color: Colors.white)),
                  Text('• pH: ${ph.toStringAsFixed(2)} - ${getPhFeedback(ph)}',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
