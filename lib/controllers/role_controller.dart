import 'package:flutter/foundation.dart';
import '../models/role.dart';

class RoleController extends ChangeNotifier {
  List<Role> _roles = [];
  Role? _selectedRole;

  List<Role> get roles => _roles;
  Role? get selectedRole => _selectedRole;

  RoleController() {
    _loadRoles();
  }

  void _loadRoles() {
    _roles = Role.predefinedRoles;
    notifyListeners();
  }

  void selectRole(Role role) {
    _selectedRole = role;
    notifyListeners();
  }

  void clearSelection() {
    _selectedRole = null;
    notifyListeners();
  }

  Role? getRoleById(String id) {
    try {
      return _roles.firstWhere((role) => role.id == id);
    } catch (e) {
      if (kDebugMode) {
        print('RoleController: Role not found: $id');
      }
      return null;
    }
  }

  Role? getRoleByName(String name) {
    try {
      return _roles.firstWhere((role) => role.name == name);
    } catch (e) {
      if (kDebugMode) {
        print('RoleController: Role not found: $name');
      }
      return null;
    }
  }
}
