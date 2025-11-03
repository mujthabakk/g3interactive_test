import 'package:flutter/material.dart';

/// App Colors
class AppColors {
  static const Color primaryYellow = Color(0xFFFCD535);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
  static const Color black87 = Colors.black87;
  static const Color grey = Colors.grey;
  
  // Status Colors
  static const Color activeGreen = Color(0xFF2E7D32);
  static const Color activeGreenLight = Color(0xFFE8F5E9);
  static const Color inactiveRed = Color(0xFFD32F2F);
  static const Color inactiveRedLight = Color(0xFFFFEBEE);
}

/// App Text Styles
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black87,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.black87,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.black87,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 15,
    color: AppColors.black87,
  );

  static const TextStyle labelText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black87,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );
}

/// App Dimensions
class AppDimensions {
  static const double borderRadius = 25.0;
  static const double borderRadiusSmall = 20.0;
  static const double borderRadiusCard = 20.0;
  static const double buttonHeight = 56.0;
  static const double inputHeight = 50.0;
  
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: 24.0);
  static const EdgeInsets paddingAll = EdgeInsets.all(16.0);
}

/// App Assets
class AppAssets {
  static const String headerFrame = 'assets/Frame 18338.png';
  static const String headerFrameAlt = 'assets/Frame 18341.png';
  static const String logo = 'assets/Vector.png';
}

/// App Shadows
class AppShadows {
  static List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, 3),
    ),
  ];

  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];
}
