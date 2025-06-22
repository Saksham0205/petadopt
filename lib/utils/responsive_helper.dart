import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < desktopBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  // Get responsive grid count based on screen size
  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 2; // Mobile: 2 columns
    if (width < 900) return 3; // Small tablet: 3 columns
    if (width < 1200) return 4; // Large tablet: 4 columns
    return 5; // Desktop: 5 columns
  }

  // Get responsive card width for horizontal lists
  static double getCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return width * 0.55; // Mobile: 55% of screen width
    if (width < 900) return 250; // Tablet: Fixed 250px
    return 300; // Desktop: Fixed 300px
  }

  // Get responsive padding
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16);
    if (isTablet(context)) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }

  // Get max content width for large screens
  static double getMaxContentWidth(BuildContext context) {
    return isDesktop(context) ? 1200 : double.infinity;
  }
} 