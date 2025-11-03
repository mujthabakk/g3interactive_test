import 'package:flutter/foundation.dart';
import '../models/apiary_role_model.dart';
import '../models/personnel_add_response_model.dart';
import '../models/single_personnel_detail_model.dart';
import '../models/personal_details_model_list.dart';
import '../services/api_service.dart';

class PersonnelAddController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool _isSubmitting = false;
  bool _isFetchingDetail = false;
  String? _errorMessage;
  List<ApiaryRoleModel> _apiaryRoles = [];
  PersonnelData? _currentPersonnelData;

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get isFetchingDetail => _isFetchingDetail;
  String? get errorMessage => _errorMessage;
  List<ApiaryRoleModel> get apiaryRoles => _apiaryRoles;
  PersonnelData? get currentPersonnelData => _currentPersonnelData;

  // Fetch Apiary Roles
  Future<bool> fetchApiaryRoles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _apiaryRoles = await _apiService.getApiaryRoles();
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Add Personnel Details
  Future<PersonnelAddResponseModel?> addPersonnelDetails({
    required String firstName,
    required String address,
    required String latitude,
    required String longitude,
    required String suburb,
    required String state,
    required String postcode,
    required String country,
    required String contactNumber,
    required List<int> roleIds,
    required bool isActive,
    String? additionalNotes,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Convert role IDs to JSON array string format
      final roleIdsString = '[${roleIds.map((id) => '"$id"').join(',')}]';
      
      final response = await _apiService.addPersonnelDetails(
        firstName: firstName,
        address: address,
        latitude: latitude,
        longitude: longitude,
        suburb: suburb,
        state: state,
        postcode: postcode,
        country: country,
        contactNumber: contactNumber,
        roleIds: roleIdsString,
        status: isActive ? '1' : '0',
        additionalNotes: additionalNotes,
      );

      _isSubmitting = false;
      notifyListeners();
      return response;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isSubmitting = false;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _isSubmitting = false;
      notifyListeners();
      return null;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Fetch Single Personnel Detail
  Future<bool> fetchPersonnelDetail(int id) async {
    _isFetchingDetail = true;
    _errorMessage = null;
    _currentPersonnelData = null;
    notifyListeners();

    try {
      final response = await _apiService.getSinglePersonnelDetail(id);
      _currentPersonnelData = response.data;
      _isFetchingDetail = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isFetchingDetail = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _isFetchingDetail = false;
      notifyListeners();
      return false;
    }
  }

  // Clear current personnel data
  void clearCurrentPersonnel() {
    _currentPersonnelData = null;
    notifyListeners();
  }
}
