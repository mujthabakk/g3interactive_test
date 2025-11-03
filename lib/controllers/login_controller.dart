import 'package:flutter/foundation.dart';
import '../models/login_model.dart';
import '../services/api_service.dart';

class LoginController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  LoginModel? _loginModel;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginModel? get loginModel => _loginModel;
  bool get isLoggedIn => _loginModel != null;

  // Login method
  Future<bool> login({
    required String email,
    required String password,
    bool isWebUser = true,
    bool isMobUser = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _loginModel = await _apiService.login(
        email: email,
        password: password,
        isWebUser: isWebUser,
        isMobUser: isMobUser,
      );

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

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _loginModel = await _apiService.getSavedLogin();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout() async {
    await _apiService.logout();
    _loginModel = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
