import 'package:flutter/material.dart';

enum DisplayType { mobile, tablet, desktop }

class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static DisplayType getDisplayType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DisplayType.mobile;
    } else if (width < tabletBreakpoint) {
      return DisplayType.tablet;
    } else {
      return DisplayType.desktop;
    }
  }

  static bool isMobile(BuildContext context) =>
      getDisplayType(context) == DisplayType.mobile;

  static bool isTablet(BuildContext context) =>
      getDisplayType(context) == DisplayType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDisplayType(context) == DisplayType.desktop;
      
  static bool isDesktopOrTablet(BuildContext context) {
    final type = getDisplayType(context);
    return type == DisplayType.desktop || type == DisplayType.tablet;
  }
}
