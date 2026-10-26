import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Screen size breakpoints following financial UI standards
class ResponsiveBreakpoints {
  static const double mobileMax = 767.0;
  static const double tabletMax = 1100.0;
  static const double desktopMin = 1101.0;
}

/// Device categories
enum DeviceScreenType {
  mobile,
  tablet,
  desktop,
}

/// Helper class for responsive queries and platform detection
class ResponsiveLayout {
  /// Checks if running on Windows desktop environment
  static bool get isWindowsDesktop {
    if (kIsWeb) return false;
    try {
      return Platform.isWindows;
    } catch (_) {
      return false;
    }
  }

  /// Checks if running on any desktop platform (Windows, macOS, Linux)
  static bool get isDesktopPlatform {
    if (kIsWeb) return false;
    try {
      return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    } catch (_) {
      return false;
    }
  }

  /// Checks if running on mobile phone OS (Android, iOS)
  static bool get isMobilePlatform {
    if (kIsWeb) return false;
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  /// Get current screen type based on layout width
  static DeviceScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= ResponsiveBreakpoints.desktopMin) {
      return DeviceScreenType.desktop;
    } else if (width >= ResponsiveBreakpoints.mobileMax) {
      return DeviceScreenType.tablet;
    } else {
      return DeviceScreenType.mobile;
    }
  }

  /// Quick booleans
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= ResponsiveBreakpoints.mobileMax;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > ResponsiveBreakpoints.mobileMax &&
        width < ResponsiveBreakpoints.desktopMin;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.desktopMin;

  /// Value selector based on screen size
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final type = getScreenType(context);
    switch (type) {
      case DeviceScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceScreenType.tablet:
        return tablet ?? mobile;
      case DeviceScreenType.mobile:
      default:
        return mobile;
    }
  }
}

/// A builder widget that provides the current screen type and constraints
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    DeviceScreenType screenType,
  ) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        DeviceScreenType screenType;
        if (constraints.maxWidth >= ResponsiveBreakpoints.desktopMin) {
          screenType = DeviceScreenType.desktop;
        } else if (constraints.maxWidth >= ResponsiveBreakpoints.mobileMax) {
          screenType = DeviceScreenType.tablet;
        } else {
          screenType = DeviceScreenType.mobile;
        }
        return builder(context, constraints, screenType);
      },
    );
  }
}
