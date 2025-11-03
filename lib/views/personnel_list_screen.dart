

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:g3interactive_test/utils/app_constants.dart';
import 'package:g3interactive_test/utils/error_handler.dart';
import 'package:g3interactive_test/widgets/custom_header.dart';
import 'package:g3interactive_test/widgets/custom_text_fields.dart';
import 'package:g3interactive_test/widgets/custom_buttons.dart';
import 'package:g3interactive_test/widgets/personnel_card.dart';
import 'package:g3interactive_test/widgets/loading_overlay.dart';
import 'package:g3interactive_test/controllers/personnel_details_controller.dart';
import 'package:g3interactive_test/controllers/login_controller.dart';
import 'package:g3interactive_test/models/personal_details_model_list.dart';
import 'package:g3interactive_test/routes/app_router.dart';

class PersonnelListScreen extends StatefulWidget {
  const PersonnelListScreen({Key? key}) : super(key: key);

  @override
  State<PersonnelListScreen> createState() => _PersonnelListScreenState();
}

class _PersonnelListScreenState extends State<PersonnelListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<PersonnelData> _personnelList = [];
  List<PersonnelData> _filteredPersonnelList = [];
  bool _isLoading = false;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterPersonnel);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchPersonnelDetails();
      });
    }
  }

  Future<void> _fetchPersonnelDetails() async {
    setState(() {
      _isLoading = true;
    });

    final personnelController = context.read<PersonnelDetailsController>();
    final success = await personnelController.fetchPersonnelDetails();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        setState(() {
          _personnelList = personnelController.personnelList;
          _filteredPersonnelList = _personnelList;
        });
      } else {
        final error = personnelController.errorMessage ?? 'Failed to fetch personnel details';
        ErrorHandler.showError(context, error);
      }
    }
  }

  void _filterPersonnel() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPersonnelList = _personnelList;
      } else {
        _filteredPersonnelList = _personnelList.where((personnel) {
          final name = '${personnel.firstName} ${personnel.lastName ?? ''}'.toLowerCase();
          final phone = personnel.contactNumber?.toLowerCase() ?? '';
          final address = personnel.address.toLowerCase();
          return name.contains(query) || phone.contains(query) || address.contains(query);
        }).toList();
      }
    });
  }

  String _getRoleNames(PersonnelData personnel) {
    if (personnel.roleDetails.isEmpty) return 'No Role';
    return personnel.roleDetails.map((r) => r.role).join(', ');
  }

  Map<String, dynamic> _convertToCardData(PersonnelData personnel) {
    return {
      'name': '${personnel.firstName} ${personnel.lastName ?? ''}'.trim(),
      'phone': personnel.contactNumber ?? 'N/A',
      'role': _getRoleNames(personnel),
      'address': personnel.address,
      'status': personnel.status == '1' ? 'Active' : 'Inactive',
      'isActive': personnel.status == '1',
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      final loginController = context.read<LoginController>();
      await loginController.logout();
      if (mounted) {
        context.go(AppRouter.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      message: 'Loading personnel...',
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            // ==================== CUSTOM APP BAR ====================
            CustomAppBar(
              title: 'Personnel Details List',
              onProfileTap: _handleLogout,
            ),

          const SizedBox(height: 20),

          // ==================== SEARCH + GO (CIRCLE) ====================
          Padding(
            padding: AppDimensions.paddingHorizontal,
            child: Row(
              children: [
                Expanded(
                  child: SearchTextField(
                    controller: _searchController,
                  ),
                ),
                const SizedBox(width: 12),
                CircleGoButton(
                  onPressed: () {
                    _filterPersonnel();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ==================== PERSONNEL LIST ====================
          Expanded(
            child: _filteredPersonnelList.isEmpty
                ? Center(
                    child: Text(
                      _isLoading ? 'Loading...' : 'No personnel found',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: AppDimensions.paddingHorizontal,
                    itemCount: _filteredPersonnelList.length,
                    itemBuilder: (context, index) {
                      final personnel = _filteredPersonnelList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: PersonnelCard(
                          data: _convertToCardData(personnel),
                          onTap: () {
                            // Navigate to detail screen with personnel ID
                            context.push(
                              '${AppRouter.personalDetails}?id=${personnel.id}',
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ==================== FAB (CIRCLE) ====================
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRouter.personalDetails);
        },
        backgroundColor: AppColors.primaryYellow,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

