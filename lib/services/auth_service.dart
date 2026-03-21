import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/auth_response.dart';
import '../models/user.dart';
import 'api_client.dart';

/// Pure API call functions — no state, no side effects.
/// AuthProvider is responsible for calling these and managing state.
class AuthService {
  AuthService._();

  // ── Register ──────────────────────────────────────────
  static Future<AuthResponse> registerUser({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'display_name': displayName,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw _parseError(response);
  }

  // ── Login ─────────────────────────────────────────────
  static Future<AuthResponse> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw _parseError(response);
  }

  // ── Refresh Token ─────────────────────────────────────
  static Future<AuthResponse> refreshToken({
    required String refreshToken,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.refresh}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw _parseError(response);
  }

  // ── Logout ────────────────────────────────────────────
  static Future<void> logoutUser() async {
    // Best-effort — we clear local tokens regardless of server response
    try {
      await ApiClient.postNoBody(ApiConstants.logout);
    } catch (_) {
      // Ignore network errors on logout
    }
  }

  // ── Fetch current user ────────────────────────────────
  static Future<User> fetchMe() async {
    final response = await ApiClient.get(ApiConstants.me);

    if (response.statusCode == 200) {
      return User.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw _parseError(response);
  }

  // ── Helpers ───────────────────────────────────────────
  static Exception _parseError(http.Response response) {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final message = json['message'] ?? json['error'] ?? json['detail'];
      if (message != null) return Exception(message.toString());
    } catch (_) {}
    return Exception('Request failed (${response.statusCode})');
  }
}
