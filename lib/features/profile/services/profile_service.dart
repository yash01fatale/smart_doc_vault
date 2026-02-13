import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ProfileService {

  static const String baseUrl =
      "http://YOUR_SERVER_IP:5000/api/users";

  static Future<UserModel?> fetchProfile(
      String token) async {

    final response = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      return null;
    }
  }
}
