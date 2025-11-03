import 'package:flutter/material.dart';
import 'package:g3interactive_test/utils/app_constants.dart';

/// Role Checkboxes Widget
class RoleCheckboxes extends StatelessWidget {
  final List<String> roles;
  final Set<String> selectedRoles;
  final ValueChanged<Set<String>> onChanged;

  const RoleCheckboxes({
    Key? key,
    required this.roles,
    required this.selectedRoles,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimensions.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: roles.map((role) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: selectedRoles.contains(role),
                    onChanged: (val) {
                      final newSet = Set<String>.from(selectedRoles);
                      if (val == true) {
                        newSet.add(role);
                      } else {
                        newSet.remove(role);
                      }
                      onChanged(newSet);
                    },
                    activeColor: AppColors.primaryYellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  role,
                  style: const TextStyle(fontSize: 15, color: AppColors.black87),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
