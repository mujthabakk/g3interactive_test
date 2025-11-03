import 'package:flutter/material.dart';
import 'package:g3interactive_test/utils/app_constants.dart';

/// Personnel Card Widget
class PersonnelCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const PersonnelCard({
    Key? key,
    required this.data,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isActive = data['isActive'] ?? false;

    // Colors based on status
    final Color bgColor = isActive
        ? AppColors.activeGreenLight
        : AppColors.inactiveRedLight;
    final Color borderColor = isActive
        ? AppColors.activeGreen
        : AppColors.inactiveRed;
    final Color textColor = isActive
        ? AppColors.activeGreen
        : AppColors.inactiveRed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppDimensions.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusCard),
          boxShadow: AppShadows.cardShadow,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                _buildAvatar(),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black87,
                              ),
                            ),
                          ),
                          // Status Badge
                          _buildStatusBadge(
                            status: data['status'] ?? 'Active',
                            bgColor: bgColor,
                            borderColor: borderColor,
                            textColor: textColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Phone + Role
                      _buildPhoneAndRole(
                        phone: data['phone'] ?? '',
                        role: data['role'] ?? '',
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Divider
            Divider(color: Colors.grey[300], height: 1),

            const SizedBox(height: 12),

            // Address
            _buildAddress(data['address'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.primaryYellow,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.people, color: AppColors.black87, size: 28),
    );
  }

  Widget _buildStatusBadge({
    required String status,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: borderColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneAndRole({required String phone, required String role}) {
    return Row(
      children: [
        const Icon(Icons.phone, size: 16, color: AppColors.grey),
        const SizedBox(width: 4),
        Text(
          phone,
          style: const TextStyle(fontSize: 14, color: AppColors.black87),
        ),
        const SizedBox(width: 8),
        const Text('•', style: TextStyle(color: AppColors.grey)),
        const SizedBox(width: 8),
        const Icon(Icons.person_outline, size: 16, color: AppColors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            role,
            style: const TextStyle(fontSize: 14, color: AppColors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAddress(String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, size: 16, color: AppColors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(fontSize: 14, color: AppColors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
