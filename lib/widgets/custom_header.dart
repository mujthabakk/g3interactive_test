import 'package:flutter/material.dart';
import 'package:g3interactive_test/utils/app_constants.dart';
import 'package:g3interactive_test/widgets/custom_buttons.dart';

/// Custom App Bar with background image and icons
class CustomAppBar extends StatelessWidget {
  final String title;
  final String backgroundImage;
  final VoidCallback? onMenuTap;
  final VoidCallback? onProfileTap;
  final bool showMenuButton;
  final bool showProfileButton;
  final IconData? profileIcon;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.backgroundImage = 'assets/Frame 18341.png',
    this.onMenuTap,
    this.onProfileTap,
    this.showMenuButton = true,
    this.showProfileButton = true,
    this.profileIcon = Icons.person_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          // Background Image
          Image.asset(
            backgroundImage,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          
          // Top Icons
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Menu Button
                if (showMenuButton)
                  MenuButton(onTap: onMenuTap)
                else
                  const SizedBox(width: 44),
                
                // Profile Icon
                if (showProfileButton)
                  CircleIconButton(
                    onTap: onProfileTap,
                    child: Icon(profileIcon, color: AppColors.black87),
                  )
                else
                  const SizedBox(width: 44),
              ],
            ),
          ),
          
          // Title (Centered)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading,
            ),
          ),
        ],
      ),
    );
  }
}

/// Login Header with logo
class LoginHeader extends StatelessWidget {
  final String backgroundImage;
  final String logoImage;
  final String appName;

  const LoginHeader({
    Key? key,
    this.backgroundImage = 'assets/Frame 18338.png',
    this.logoImage = 'assets/Vector.png',
    this.appName = 'BEE CHEM',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      child: Stack(
        children: [
          Image.asset(
            backgroundImage,
            width: screenWidth,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  logoImage,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 12),
                Text(
                  appName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black87,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section Label
class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: AppTextStyles.labelText,
      ),
    );
  }
}
