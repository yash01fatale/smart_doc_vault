import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl =
      "http://localhost:8000/api/auth"; // ✅ FOR FLUTTER WEB

  // ✅ SIGNUP
  static Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String mobile,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse("$baseUrl/signup");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "fullName": fullName,
        "email": email,
        "mobile": mobile,
        "password": password,
        "role": role,
      }),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"]);
    }
  }
static Future<void> resendOtp(String userId) async {
  await http.post(
    Uri.parse("$baseUrl/resend-otp"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"userId": userId}),
  );
}

  // ✅ LOGIN
  static Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {

  final response = await http.post(
    Uri.parse("$baseUrl/login"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  return jsonDecode(response.body);
}
static Future<Map<String, dynamic>> enable2FA(String userId) async {
  final response = await http.post(
    Uri.parse("$baseUrl/api/auth/enable-2fa"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "userId": userId,
    }),
  );

  return jsonDecode(response.body);
}

static Future<Map<String, dynamic>> verifyOtp({
  required String userId,
  required String otp,
}) async {

  final response = await http.post(
    Uri.parse("$baseUrl/verify-otp"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "userId": userId,
      "otp": otp,
    }),
  );

  return jsonDecode(response.body);
}

  static forgotPassword({required String email}) {}

  static Future<Map<String, dynamic>> verify2FA({
  required String userId,
  required String token,
}) async {
  final response = await http.post(
    Uri.parse("$baseUrl/api/auth/login-2fa"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "userId": userId,
      "token": token,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception("Invalid code");
  }

  return jsonDecode(response.body);
}

}
