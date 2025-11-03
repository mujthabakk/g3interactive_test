import 'package:flutter/material.dart';
import 'package:g3interactive_test/utils/app_constants.dart';

/// Status Toggle Widget
class StatusToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;
  final String label;

  const StatusToggle({
    Key? key,
    required this.isActive,
    required this.onChanged,
    this.label = 'Status',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.labelText,
          ),
          Switch(
            value: isActive,
            onChanged: onChanged,
            activeColor: AppColors.white,
            activeTrackColor: const Color(0xFF4CAF50),
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
