import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { personal, business }

class RoleController extends ChangeNotifier {
  static const String _roleKey = "userRole";

  UserRole? _role;

  UserRole? get role => _role;

  RoleController() {
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString(_roleKey);

    if (roleString != null) {
      _role =
          roleString == "business" ? UserRole.business : UserRole.personal;
      notifyListeners();
    }
  }

  Future<void> setRole(UserRole role) async {
    _role = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _roleKey,
      role == UserRole.business ? "business" : "personal",
    );
    notifyListeners();
  }

  bool get hasRoleSelected => _role != null;
}
