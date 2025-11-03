import 'package:flutter/foundation.dart';
import '../models/personal_details_model_list.dart';
import '../services/api_service.dart';

class PersonnelDetailsController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  PersonalDetailsModel? _personnelDetailsModel;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PersonalDetailsModel? get personnelDetailsModel => _personnelDetailsModel;
  List<PersonnelData> get personnelList => _personnelDetailsModel?.data ?? [];

  // Fetch personnel details
  Future<bool> fetchPersonnelDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _personnelDetailsModel = await _apiService.getPersonnelDetails();
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

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear data
  void clearData() {
    _personnelDetailsModel = null;
    _errorMessage = null;
    notifyListeners();
  }
}
