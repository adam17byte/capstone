import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF9800);
  static const Color white = Colors.white;
  static const Color black54 = Colors.black54;
}

class AppTextStyles {
  static const TextStyle bannerTitle = TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bannerDesc = TextStyle(
    color: Colors.white,
    fontSize: 15,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.primary,
  );

  static const TextStyle cardDesc = TextStyle(fontSize: 12.5, height: 1.4);

  static const TextStyle buttonText = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );
}