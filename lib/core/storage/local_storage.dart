import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveAuthData(
    String token,
    String role,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    await prefs.setString("role", role);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  static Future<bool> isFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("first_time") ?? true;
}

static Future<void> setNotFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("first_time", false);
}
static Future<void> saveSelectedRole(String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("selected_role", role);
}

static Future<String?> getSelectedRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("selected_role");
}
static Future<void> setOnboardingSeen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("onboarding_seen", true);
}

static Future<bool> isOnboardingSeen() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("onboarding_seen") ?? false;
}


}
