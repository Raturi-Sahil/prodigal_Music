import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId = 'user_id';
  static const _keyUserEmail = 'user_email';
  static const _keyUserDisplayName = 'user_display_name';

  // ── Save ──────────────────────────────────────────────
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
    ]);
  }

  static Future<void> saveUser({
    required String userId,
    required String email,
    required String displayName,
  }) async {
    await Future.wait([
      _storage.write(key: _keyUserId, value: userId),
      _storage.write(key: _keyUserEmail, value: email),
      _storage.write(key: _keyUserDisplayName, value: displayName),
    ]);
  }

  // ── Read ───────────────────────────────────────────────
  static Future<String?> getAccessToken() =>
      _storage.read(key: _keyAccessToken);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefreshToken);

  static Future<String?> getUserId() => _storage.read(key: _keyUserId);

  static Future<String?> getUserEmail() => _storage.read(key: _keyUserEmail);

  static Future<String?> getUserDisplayName() =>
      _storage.read(key: _keyUserDisplayName);

  // ── Clear ──────────────────────────────────────────────
  static Future<void> clearAll() => _storage.deleteAll();
}
