/// Centralized API constants.
class ApiConstants {
  ApiConstants._();

  // ── Base URL ──────────────────────────────────────────
  // Use 'http://127.0.0.1:8000' for iOS Simulator / physical device on same network.
  // Use 'http://10.0.2.2:8000' for Android Emulator.
  static const String baseUrl = 'http://127.0.0.1:8000';

  // ── Auth endpoints ────────────────────────────────────
  static const String register = '/v1/auth/register';
  static const String login = '/v1/auth/login';
  static const String refresh = '/v1/auth/refresh';
  static const String logout = '/v1/auth/logout';
  static const String me = '/v1/me';
}
