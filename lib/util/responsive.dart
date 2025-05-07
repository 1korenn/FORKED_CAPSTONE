import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    if (isMobile(context)) {
      return baseFontSize * 0.9; // Slightly smaller font for mobile
    } else if (isTablet(context)) {
      return baseFontSize * 1.1; // Slightly larger font for tablet
    } else {
      return baseFontSize * 1.3; // Larger font for desktop
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context, EdgeInsets basePadding) {
    if (isMobile(context)) {
      return basePadding * 0.8; // Reduce padding for mobile
    } else if (isTablet(context)) {
      return basePadding * 1.2; // Increase padding for tablet
    } else {
      return basePadding * 1.5; // Larger padding for desktop
    }
  }
}
