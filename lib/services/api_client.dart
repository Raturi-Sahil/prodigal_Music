import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'token_storage.dart';

/// Base HTTP client that:
/// - Attaches `Authorization: Bearer <access_token>` to every request
/// - On 401: silently refreshes the token and retries the request once
/// - On second 401: clears all tokens (user must re-login)
class ApiClient {
  ApiClient._();

  // ── Public helpers ────────────────────────────────────

  static Future<http.Response> get(String path) async {
    return _executeWithRetry(() async {
      final token = await TokenStorage.getAccessToken();
      return http.get(
        Uri.parse('${ApiConstants.baseUrl}$path'),
        headers: _headers(token),
      );
    });
  }

  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _executeWithRetry(() async {
      final token = await TokenStorage.getAccessToken();
      return http.post(
        Uri.parse('${ApiConstants.baseUrl}$path'),
        headers: _headers(token),
        body: jsonEncode(body),
      );
    });
  }

  /// POST with no body (e.g., logout)
  static Future<http.Response> postNoBody(String path) async {
    return _executeWithRetry(() async {
      final token = await TokenStorage.getAccessToken();
      return http.post(
        Uri.parse('${ApiConstants.baseUrl}$path'),
        headers: _headers(token),
      );
    });
  }

  // ── Internal ──────────────────────────────────────────

  static Map<String, String> _headers(String? token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<http.Response> _executeWithRetry(
    Future<http.Response> Function() request,
  ) async {
    final response = await request();

    if (response.statusCode != 401) return response;

    // ── 401: attempt a token refresh ───────────────────
    final refreshed = await _tryRefresh();
    if (!refreshed) return response; // propagate 401 to caller

    // Retry the original request once with the new token
    return request();
  }

  static Future<bool> _tryRefresh() async {
    try {
      final storedRefresh = await TokenStorage.getRefreshToken();
      if (storedRefresh == null || storedRefresh.isEmpty) return false;

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.refresh}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': storedRefresh}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        await TokenStorage.saveTokens(
          accessToken: json['access_token'] as String,
          refreshToken: json['refresh_token'] as String,
        );
        return true;
      }

      // Refresh also failed — clear everything so the app can redirect to login
      await TokenStorage.clearAll();
      return false;
    } catch (_) {
      await TokenStorage.clearAll();
      return false;
    }
  }
}
