import 'package:flutter/material.dart';
import 'package:g3interactive_test/utils/app_constants.dart';

/// Custom Text Field with Icon and optional eye toggle
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isPassword;
  final VoidCallback? onToggle;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.isPassword = false,
    this.onToggle,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.inputHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.lightShadow,
      ),
      child: Row(
        children: [
          // Circle Icon
          Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.grey[700], size: 20),
          ),

          const SizedBox(width: 16),

          // Text Input
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 16, color: AppColors.black87),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),

          // Eye Icon (only for password)
          if (isPassword)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: onToggle,
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[500],
                  size: 20,
                ),
              ),
            )
          else
            const SizedBox(width: 20),
        ],
      ),
    );
  }
}

/// Simple Text Field (for forms)
class SimpleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const SimpleTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxLines == 1 ? AppDimensions.inputHeight : null,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}

/// Address Text Field with location icons
class AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback? onLocationTap;

  const AddressTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.inputHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.location_on_outlined, color: Colors.black, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.my_location, color: Colors.black, size: 20),
              onPressed: onLocationTap ?? () {},
            ),
          ),
        ],
      ),
    );
  }
}

/// Notes Text Field with character counter
class NotesTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLength;

  const NotesTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.maxLength = 500,
  }) : super(key: key);

  @override
  State<NotesTextField> createState() => _NotesTextFieldState();
}

class _NotesTextFieldState extends State<NotesTextField> {
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateLength);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateLength);
    super.dispose();
  }

  void _updateLength() {
    setState(() {
      _currentLength = widget.controller.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          TextField(
            controller: widget.controller,
            maxLines: 4,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$_currentLength/${widget.maxLength}',
                style: const TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Search Text Field
class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const SearchTextField({
    Key? key,
    required this.controller,
    this.hint = 'Search...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.inputHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.grey, fontSize: 15),
          prefixIcon: const Icon(Icons.search, color: AppColors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
