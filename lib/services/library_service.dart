import 'dart:convert';
import '../constants/api_constants.dart';
import '../models/api_playlist.dart';
import '../models/library_track.dart';
import '../models/recently_played_track.dart';
import 'api_client.dart';

/// Pure API calls for the Library feature — no state, no side effects.
class LibraryService {
  LibraryService._();

  // ── GET /v1/library (liked songs) ──────────────────────
  static Future<List<LibraryTrack>> getLibrary() async {
    final response = await ApiClient.get(ApiConstants.library);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final tracks = json['tracks'] as List<dynamic>;
      return tracks
          .map((t) => LibraryTrack.fromJson(t as Map<String, dynamic>))
          .toList();
    }
    throw _parseError(response);
  }

  // ── GET /v1/playlists ──────────────────────────────────
  static Future<List<ApiPlaylist>> getPlaylists() async {
    final response = await ApiClient.get(ApiConstants.playlists);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final playlists = json['playlists'] as List<dynamic>;
      return playlists
          .map((p) => ApiPlaylist.fromJson(p as Map<String, dynamic>))
          .toList();
    }
    throw _parseError(response);
  }

  // ── GET /v1/recently-played ────────────────────────────
  static Future<List<RecentlyPlayedTrack>> getRecentlyPlayed() async {
    final response = await ApiClient.get(ApiConstants.recentlyPlayed);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final tracks = json['tracks'] as List<dynamic>;
      return tracks
          .map((t) => RecentlyPlayedTrack.fromJson(t as Map<String, dynamic>))
          .toList();
    }
    throw _parseError(response);
  }

  // ── POST /v1/tracks/{trackId}/like ─────────────────────
  static Future<void> likeTrack(String trackId) async {
    final response =
        await ApiClient.postNoBody(ApiConstants.trackLike(trackId));
    if (response.statusCode == 200 || response.statusCode == 201) return;
    throw _parseError(response);
  }

  // ── DELETE /v1/tracks/{trackId}/like ───────────────────
  static Future<void> unlikeTrack(String trackId) async {
    final response = await ApiClient.delete(ApiConstants.trackLike(trackId));
    if (response.statusCode == 200 || response.statusCode == 204) return;
    throw _parseError(response);
  }

  // ── POST /v1/playlists ────────────────────────────────
  static Future<ApiPlaylist> createPlaylist({
    required String title,
    required String description,
    bool isPublic = false,
  }) async {
    final response = await ApiClient.post(ApiConstants.playlists, {
      'title': title,
      'description': description,
      'is_public': isPublic,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final playlist = json['playlist'] as Map<String, dynamic>;
      return ApiPlaylist.fromJson(playlist);
    }
    throw _parseError(response);
  }

  // ── Helpers ────────────────────────────────────────────
  static Exception _parseError(dynamic response) {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final message = json['message'] ?? json['error'] ?? json['detail'];
      if (message != null) return Exception(message.toString());
    } catch (_) {}
    return Exception('Request failed (${response.statusCode})');
  }
}
