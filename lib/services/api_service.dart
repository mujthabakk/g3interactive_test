import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_model.dart';
import '../models/personal_details_model_list.dart';
import '../models/apiary_role_model.dart';
import '../models/personnel_add_response_model.dart';
import '../models/single_personnel_detail_model.dart';

class ApiService {
  static const String _baseUrl = 'https://beechem.ishtech.live/api';
  static const String _loginKey = 'login_response';

  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
      ),
    );

    // Add Auth Interceptor to automatically add Bearer token
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          // Skip adding token for login endpoint
          if (!options.path.contains('/login')) {
            try {
              final prefs = await SharedPreferences.getInstance();
              final jsonString = prefs.getString(_loginKey);
              
              if (jsonString != null) {
                final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
                final login = LoginModel.fromJson(jsonMap);
                
                if (login.accessToken.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer ${login.accessToken}';
                  print('✅ Bearer token added to request');
                } else {
                  print('❌ Access token is empty');
                }
              } else {
                print('❌ No saved login found in SharedPreferences');
              }
            } catch (e) {
              print('❌ Error retrieving token: $e');
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle 401 unauthorized errors
          if (error.response?.statusCode == 401) {
            // Token expired or invalid - could trigger logout here
            print('Unauthorized - Token may be invalid or expired');
          }
          return handler.next(error);
        },
      ),
    );

    // Add Dio Logger only in debug mode (AFTER auth interceptor)
    if (bool.fromEnvironment('dart.vm.product') == false) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  // Login API Call
  Future<LoginModel> login({
    required String email,
    required String password,
    required bool isWebUser,
    required bool isMobUser,
  }) async {
    try {
      final formData = {
        'email': email,
        'password': password,
        'web_user': isWebUser ? '1' : '0',
        'mob_user': isMobUser ? '1' : '0',
      };

      final response = await _dio.post(
        '/login',
        data: FormData.fromMap(formData),
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
      );

      if (response.statusCode == 200) {
        final loginModel = LoginModel.fromJson(response.data);

        // Store login response locally
        await _saveLoginResponse(loginModel);

        return loginModel;
      } else {
        throw ApiException('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } catch (e) {
      throw ApiException('An unexpected error occurred. Please try again.');
    }
  }

  // Save login response to SharedPreferences
  Future<void> _saveLoginResponse(LoginModel loginModel) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(loginModel.toJson());
    await prefs.setString(_loginKey, jsonString);
  }

  // Get saved login response
  Future<LoginModel?> getSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_loginKey);
    if (jsonString == null) return null;

    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // Check if old format (camelCase) and clear if so
      if (jsonMap.containsKey('accessToken')) {
        print('⚠️ Old token format detected, clearing...');
        await prefs.remove(_loginKey);
        return null;
      }
      
      return LoginModel.fromJson(jsonMap);
    } catch (e) {
      print('Error parsing login data: $e');
      // Clear corrupted data
      await prefs.remove(_loginKey);
      return null;
    }
  }

  // Logout: Clear saved login
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final login = await getSavedLogin();
    return login != null && login.accessToken.isNotEmpty;
  }

  // Get Personnel Details API Call
  Future<PersonalDetailsModel> getPersonnelDetails() async {
    try {
      final response = await _dio.get('/personnel-details');

      if (response.statusCode == 200) {
        return PersonalDetailsModel.fromJson(response.data);
      } else {
        throw ApiException('Failed to fetch personnel details: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } catch (e) {
      throw ApiException('An unexpected error occurred. Please try again.');
    }
  }

  // Get Single Personnel Detail by ID
  Future<SinglePersonnelDetailModel> getSinglePersonnelDetail(int id) async {
    try {
      final response = await _dio.get('/personnel-details/$id');

      if (response.statusCode == 200) {
        return SinglePersonnelDetailModel.fromJson(response.data);
      } else {
        throw ApiException('Failed to fetch personnel detail: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } catch (e) {
      throw ApiException('An unexpected error occurred. Please try again.');
    }
  }

  // Get Apiary Roles API Call
  Future<List<ApiaryRoleModel>> getApiaryRoles() async {
    try {
      final response = await _dio.get('/roles/apiary-roles');

      if (response.statusCode == 200) {
        final List<dynamic> rolesJson = response.data as List;
        return rolesJson.map((json) => ApiaryRoleModel.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to fetch roles: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } catch (e) {
      throw ApiException('An unexpected error occurred. Please try again.');
    }
  }

  // Add Personnel Details API Call
  Future<PersonnelAddResponseModel> addPersonnelDetails({
    required String firstName,
    required String address,
    required String latitude,
    required String longitude,
    required String suburb,
    required String state,
    required String postcode,
    required String country,
    required String contactNumber,
    required String roleIds,
    required String status,
    String? additionalNotes,
  }) async {
    try {
      final formData = {
        'first_name': firstName,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'suburb': suburb,
        'state': state,
        'postcode': postcode,
        'country': country,
        'contact_number': contactNumber,
        'role_ids': roleIds,
        'status': status,
        if (additionalNotes != null && additionalNotes.isNotEmpty)
          'additional_notes': additionalNotes,
      };

      final response = await _dio.post(
        '/personnel-details/add',
        data: FormData.fromMap(formData),
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
      );

      if (response.statusCode == 200) {
        return PersonnelAddResponseModel.fromJson(response.data);
      } else {
        throw ApiException('Failed to add personnel: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } catch (e) {
      throw ApiException('An unexpected error occurred. Please try again.');
    }
  }

  // Error handling for Dio
  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timed out. Please try again.');
      case DioExceptionType.badResponse:
        final message = error.response?.data is Map
            ? error.response?.data['message'] ?? 'Server error'
            : 'Server error';
        return ApiException(message);
      case DioExceptionType.cancel:
        return ApiException('Request cancelled.');
      case DioExceptionType.connectionError:
        return ApiException('Network error. Please check your connection.');
      default:
        return ApiException('Something went wrong. Please try again.');
    }
  }
}

// Custom Exception Class
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
