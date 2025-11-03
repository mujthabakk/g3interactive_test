import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/login_screen.dart';
import '../views/personnel_list_screen.dart';
import '../views/personal_detils_screen.dart';
import '../services/api_service.dart';

class AppRouter {
  static const String login = '/';
  static const String personnelList = '/personnel-list';
  static const String personalDetails = '/personal-details';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    redirect: (context, state) async {
      // Check if user is already logged in
      final apiService = ApiService();
      final savedLogin = await apiService.getSavedLogin();
      
      final isLoggedIn = savedLogin != null && savedLogin.accessToken.isNotEmpty;
      final isLoginPage = state.matchedLocation == login;
      
      // If user is logged in and trying to access login page, redirect to personnel list
      if (isLoggedIn && isLoginPage) {
        return personnelList;
      }
      
      // If user is not logged in and trying to access protected pages, redirect to login
      if (!isLoggedIn && !isLoginPage) {
        return login;
      }
      
      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: personnelList,
        name: 'personnelList',
        builder: (context, state) => const PersonnelListScreen(),
      ),
      GoRoute(
        path: personalDetails,
        name: 'personalDetails',
        builder: (context, state) {
          final idParam = state.uri.queryParameters['id'];
          final personnelId = idParam != null ? int.tryParse(idParam) : null;
          return PersonnelDetailsScreen(personnelId: personnelId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
