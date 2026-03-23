/// Centralized API constants.
class ApiConstants {
  ApiConstants._();

  // ── Base URL ──────────────────────────────────────────
  static const String baseUrl = 'https://dhanur-music-api.onrender.com';


  // ── Auth endpoints ────────────────────────────────────
  static const String register = '/v1/auth/register';
  static const String login = '/v1/auth/login';
  static const String refresh = '/v1/auth/refresh';
  static const String logout = '/v1/auth/logout';
  static const String me = '/v1/me';

  // ── Library endpoints ──────────────────────────────────
  static const String library = '/v1/library';
  static const String playlists = '/v1/playlists';
  static const String recentlyPlayed = '/v1/recently-played';

  /// Returns the like/unlike path for a specific track.
  static String trackLike(String trackId) => '/v1/tracks/$trackId/like';
}
