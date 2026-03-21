import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // ── Getters ───────────────────────────────────────────
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _isLoading;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  // ── Auto Login (called from SplashScreen) ─────────────
  Future<void> tryAutoLogin() async {
    _setLoading(true);
    try {
      final token = await TokenStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        _setUnauthenticated();
        return;
      }

      // Token exists — verify it by fetching the current user
      final user = await AuthService.fetchMe();
      _setAuthenticated(user);
    } catch (_) {
      // Token is invalid or expired and refresh also failed
      await TokenStorage.clearAll();
      _setUnauthenticated();
    } finally {
      _setLoading(false);
    }
  }

  // ── Login ─────────────────────────────────────────────
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _clearError();
    _setLoading(true);
    try {
      final authResponse = await AuthService.loginUser(
        email: email,
        password: password,
      );

      await TokenStorage.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );

      if (authResponse.user != null) {
        await TokenStorage.saveUser(
          userId: authResponse.user!.id,
          email: authResponse.user!.email,
          displayName: authResponse.user!.displayName,
        );
        _setAuthenticated(authResponse.user!);
      } else {
        // Edge case: fetch user separately if not in response
        final user = await AuthService.fetchMe();
        await TokenStorage.saveUser(
          userId: user.id,
          email: user.email,
          displayName: user.displayName,
        );
        _setAuthenticated(user);
      }
      return true;
    } catch (e) {
      _setError(_friendlyError(e));
      _setUnauthenticated();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Register ──────────────────────────────────────────
  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _clearError();
    _setLoading(true);
    try {
      final authResponse = await AuthService.registerUser(
        email: email,
        password: password,
        displayName: displayName,
      );

      await TokenStorage.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );

      if (authResponse.user != null) {
        await TokenStorage.saveUser(
          userId: authResponse.user!.id,
          email: authResponse.user!.email,
          displayName: authResponse.user!.displayName,
        );
        _setAuthenticated(authResponse.user!);
      } else {
        final user = await AuthService.fetchMe();
        await TokenStorage.saveUser(
          userId: user.id,
          email: user.email,
          displayName: user.displayName,
        );
        _setAuthenticated(user);
      }
      return true;
    } catch (e) {
      _setError(_friendlyError(e));
      _setUnauthenticated();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Logout ────────────────────────────────────────────
  Future<void> logout() async {
    _setLoading(true);
    try {
      await AuthService.logoutUser();
    } finally {
      await TokenStorage.clearAll();
      _user = null;
      _status = AuthStatus.unauthenticated;
      _setLoading(false);
    }
  }

  // ── Private helpers ───────────────────────────────────
  void _setAuthenticated(User user) {
    _user = user;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  void _setUnauthenticated() {
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _friendlyError(Object e) {
    final msg = e.toString().replaceFirst('Exception: ', '');
    if (msg.contains('SocketException') ||
        msg.contains('Connection refused') ||
        msg.contains('Network')) {
      return 'Cannot connect to server. Check your connection.';
    }
    return msg.isNotEmpty ? msg : 'Something went wrong. Please try again.';
  }
}
