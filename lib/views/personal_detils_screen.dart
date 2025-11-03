import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:g3interactive_test/utils/app_constants.dart';
import 'package:g3interactive_test/utils/error_handler.dart';
import 'package:g3interactive_test/utils/validators.dart';
import 'package:g3interactive_test/widgets/custom_header.dart';
import 'package:g3interactive_test/widgets/custom_text_fields.dart';
import 'package:g3interactive_test/widgets/custom_buttons.dart';
import 'package:g3interactive_test/widgets/status_toggle.dart';
import 'package:g3interactive_test/widgets/loading_overlay.dart';
import 'package:g3interactive_test/controllers/personnel_add_controller.dart';
import 'package:g3interactive_test/models/apiary_role_model.dart';

class PersonnelDetailsScreen extends StatefulWidget {
  final int? personnelId;
  
  const PersonnelDetailsScreen({Key? key, this.personnelId}) : super(key: key);

  @override
 State<PersonnelDetailsScreen> createState() => _PersonnelDetailsScreenState();
}

class _PersonnelDetailsScreenState extends State<PersonnelDetailsScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _suburbController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  Set<int> _selectedRoleIds = {};
  bool _isActive = true;
  bool _hasInitialized = false;
  List<ApiaryRoleModel> _apiaryRoles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.personnelId != null) {
          _fetchPersonnelDetail(widget.personnelId!);
        } else {
          _fetchApiaryRoles();
        }
      });
    }
  }

  Future<void> _fetchApiaryRoles() async {
    final controller = context.read<PersonnelAddController>();
    final success = await controller.fetchApiaryRoles();

    if (mounted) {
      if (success) {
        setState(() {
          _apiaryRoles = controller.apiaryRoles;
        });
      } else {
        final error = controller.errorMessage ?? 'Failed to fetch roles';
        ErrorHandler.showError(context, error);
      }
    }
  }

  Future<void> _fetchPersonnelDetail(int id) async {
    final controller = context.read<PersonnelAddController>();
    
    // First fetch roles
    await controller.fetchApiaryRoles();
    
    // Then fetch personnel detail
    final success = await controller.fetchPersonnelDetail(id);

    if (mounted) {
      if (success && controller.currentPersonnelData != null) {
        final data = controller.currentPersonnelData!;
        
        // Populate form fields
        setState(() {
          _apiaryRoles = controller.apiaryRoles;
          _fullNameController.text = data.firstName;
          _addressController.text = data.address;
          _suburbController.text = data.suburb ?? '';
          _stateController.text = data.state ?? '';
          _postCodeController.text = data.postcode ?? '';
          _countryController.text = data.country ?? '';
          _contactController.text = data.contactNumber ?? '';
          _latitudeController.text = data.latitude ?? '';
          _longitudeController.text = data.longitude ?? '';
          _notesController.text = data.additionalNotes ?? '';
          
          // Set status
          _isActive = data.status == '1';
          
          // Set selected roles
          _selectedRoleIds = data.roleDetails.map((r) => r.id).toSet();
        });
      } else {
        final error = controller.errorMessage ?? 'Failed to fetch personnel details';
        ErrorHandler.showError(context, error);
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _suburbController.dispose();
    _stateController.dispose();
    _postCodeController.dispose();
    _countryController.dispose();
    _contactController.dispose();
    _notesController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.personnelId != null;
    
    return Consumer<PersonnelAddController>(
      builder: (context, controller, child) {
        return LoadingOverlay(
          isLoading: controller.isLoading || controller.isSubmitting || controller.isFetchingDetail,
          message: controller.isSubmitting 
              ? 'Saving...' 
              : controller.isFetchingDetail
                  ? 'Loading personnel details...'
                  : 'Loading roles...',
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Column(
              children: [
                // ==================== CUSTOM APP BAR ====================
                CustomAppBar(
                  title: isEditMode ? 'Edit Personnel Details' : 'Personnel Details',
                  profileIcon: Icons.person,
                ),

              // ==================== SCROLLABLE FORM ====================
              Expanded(
                child: SingleChildScrollView(
                  padding: AppDimensions.paddingHorizontal.add(
                    const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionLabel(text: 'Full name'),
                      SimpleTextField(
                        controller: _fullNameController,
                        hint: 'Please type',
                      ),

                      const SizedBox(height: 16),
                      const SectionLabel(text: 'Address'),
                      AddressTextField(
                        controller: _addressController,
                        hint: 'Please type',
                        onLocationTap: () {
                          // Handle location tap
                        },
                      ),

                      const SizedBox(height: 16),
                      const SectionLabel(text: 'Suburb'),
                      SimpleTextField(
                        controller: _suburbController,
                        hint: 'Please type',
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionLabel(text: 'State'),
                                SimpleTextField(
                                  controller: _stateController,
                                  hint: 'Please type',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionLabel(text: 'Post code'),
                                SimpleTextField(
                                  controller: _postCodeController,
                                  hint: 'Please type',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const SectionLabel(text: 'Country'),
                      SimpleTextField(
                        controller: _countryController,
                        hint: 'Please type',
                      ),

                      const SizedBox(height: 16),
                      const SectionLabel(text: 'Contact number'),
                      SimpleTextField(
                        controller: _contactController,
                        hint: 'Please type',
                      ),

                      const SizedBox(height: 16),
                      const SectionLabel(text: 'Latitude'),
                      SimpleTextField(
                        controller: _latitudeController,
                        hint: 'Please type',
                      ),

                      const SizedBox(height: 16),
                      const SectionLabel(text: 'Longitude'),
                      SimpleTextField(
                        controller: _longitudeController,
                        hint: 'Please type',
                      ),

                      const SizedBox(height: 16),
                      const SectionLabel(text: 'Role'),
                      _buildRoleCheckboxes(),

                      const SizedBox(height: 16),
                      const SectionLabel(text: 'Additional Notes'),
                      NotesTextField(
                        controller: _notesController,
                        hint: 'Please type',
                      ),

                      const SizedBox(height: 16),
                      StatusToggle(
                        isActive: _isActive,
                        onChanged: (val) => setState(() => _isActive = val),
                      ),

                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              text: 'CANCEL',
                              onPressed: () => context.pop(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ActionButton(
                              text: 'SAVE',
                              onPressed: _handleSave,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        );
      },
    );
  }

  Widget _buildRoleCheckboxes() {
    if (_apiaryRoles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Loading roles...',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: _apiaryRoles.map((role) {
        final isSelected = _selectedRoleIds.contains(role.id);
        return CheckboxListTile(
          title: Text(role.role),
          value: isSelected,
          activeColor: AppColors.primaryYellow,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedRoleIds.add(role.id);
              } else {
                _selectedRoleIds.remove(role.id);
              }
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }

  // ==================== SAVE HANDLER ====================
  Future<void> _handleSave() async {
    // Validate required fields
    if (_fullNameController.text.trim().isEmpty) {
      ErrorHandler.showError(context, 'Full name is required');
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      ErrorHandler.showError(context, 'Address is required');
      return;
    }

    if (_contactController.text.trim().isEmpty) {
      ErrorHandler.showError(context, 'Contact number is required');
      return;
    }

    if (_latitudeController.text.trim().isEmpty) {
      ErrorHandler.showError(context, 'Latitude is required');
      return;
    }

    if (_longitudeController.text.trim().isEmpty) {
      ErrorHandler.showError(context, 'Longitude is required');
    }

    if (_selectedRoleIds.isEmpty) {
      ErrorHandler.showError(context, 'Please select at least one role');
      return;
    }

    // Call API
    final controller = context.read<PersonnelAddController>();
    final response = await controller.addPersonnelDetails(
      firstName: _fullNameController.text.trim(),
      address: _addressController.text.trim(),
      latitude: _latitudeController.text.trim(),
      longitude: _longitudeController.text.trim(),
      suburb: _suburbController.text.trim(),
      state: _stateController.text.trim(),
      postcode: _postCodeController.text.trim(),
      country: _countryController.text.trim(),
      contactNumber: _contactController.text.trim(),
      roleIds: _selectedRoleIds.toList(),
      isActive: _isActive,
      additionalNotes: _notesController.text.trim().isEmpty 
          ? null 
          : _notesController.text.trim(),
    );

    if (!mounted) return;

    if (response != null && response.status) {
      ErrorHandler.showSuccess(context, response.message);
      // Navigate back
      context.pop();
    } else {
      final error = controller.errorMessage ?? 'Failed to save personnel details';
      ErrorHandler.showError(context, error);
    }
  }
}
