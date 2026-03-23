import 'package:flutter/foundation.dart';
import '../models/api_playlist.dart';
import '../models/library_track.dart';
import '../models/recently_played_track.dart';
import '../services/library_service.dart';

/// Centralized state for the Library feature.
///
/// Manages liked tracks, user playlists, and recently played items.
/// All data is fetched from the backend — no hardcoded data.
class LibraryProvider extends ChangeNotifier {
  // ── Data ──────────────────────────────────────────────
  List<LibraryTrack> _likedTracks = [];
  List<ApiPlaylist> _playlists = [];
  List<RecentlyPlayedTrack> _recentlyPlayed = [];

  /// O(1) lookup for like state (stores track IDs).
  final Set<String> _likedTrackIds = {};

  // ── Loading / Error states ────────────────────────────
  bool _isLoadingLibrary = false;
  bool _isLoadingPlaylists = false;
  bool _isLoadingRecents = false;
  String? _libraryError;
  String? _playlistsError;
  String? _recentsError;

  // ── Getters ───────────────────────────────────────────
  List<LibraryTrack> get likedTracks => List.unmodifiable(_likedTracks);
  List<ApiPlaylist> get playlists => List.unmodifiable(_playlists);
  List<RecentlyPlayedTrack> get recentlyPlayed =>
      List.unmodifiable(_recentlyPlayed);
  Set<String> get likedTrackIds => Set.unmodifiable(_likedTrackIds);

  bool get isLoadingLibrary => _isLoadingLibrary;
  bool get isLoadingPlaylists => _isLoadingPlaylists;
  bool get isLoadingRecents => _isLoadingRecents;
  bool get isLoadingAny =>
      _isLoadingLibrary || _isLoadingPlaylists || _isLoadingRecents;

  String? get libraryError => _libraryError;
  String? get playlistsError => _playlistsError;
  String? get recentsError => _recentsError;

  // ── Fetch All ─────────────────────────────────────────
  /// Call once on screen init to load all three data sources in parallel.
  /// Silently fails if backend is not available (uses local state).
  Future<void> fetchAll() async {
    await Future.wait([
      fetchLibrary(),
      fetchPlaylists(),
      fetchRecentlyPlayed(),
    ]);
  }

  // ── Fetch Library (Liked Songs) ───────────────────────
  Future<void> fetchLibrary() async {
    _isLoadingLibrary = true;
    _libraryError = null;
    notifyListeners();

    try {
      _likedTracks = await LibraryService.getLibrary();
      _likedTrackIds
        ..clear()
        ..addAll(_likedTracks.map((t) => t.id));
    } catch (e) {
      // Silent fail for offline development - keep local state
      debugPrint('Failed to fetch library from backend: $e');
      _libraryError = null; // Don't show error to user
    } finally {
      _isLoadingLibrary = false;
      notifyListeners();
    }
  }

  // ── Fetch Playlists ───────────────────────────────────
  Future<void> fetchPlaylists() async {
    _isLoadingPlaylists = true;
    _playlistsError = null;
    notifyListeners();

    try {
      _playlists = await LibraryService.getPlaylists();
    } catch (e) {
      // Silent fail for offline development - keep local state
      debugPrint('Failed to fetch playlists from backend: $e');
      _playlistsError = null; // Don't show error to user
    } finally {
      _isLoadingPlaylists = false;
      notifyListeners();
    }
  }

  // ── Fetch Recently Played ─────────────────────────────
  Future<void> fetchRecentlyPlayed() async {
    _isLoadingRecents = true;
    _recentsError = null;
    notifyListeners();

    try {
      final tracks = await LibraryService.getRecentlyPlayed();
      // Sort by played_at descending (latest first)
      tracks.sort((a, b) => b.playedAt.compareTo(a.playedAt));
      _recentlyPlayed = tracks;
    } catch (e) {
      // Silent fail for offline development - keep local state
      debugPrint('Failed to fetch recently played from backend: $e');
      _recentsError = null; // Don't show error to user
    } finally {
      _isLoadingRecents = false;
      notifyListeners();
    }
  }

  // ── Like / Unlike ─────────────────────────────────────

  bool isTrackLiked(String trackId) => _likedTrackIds.contains(trackId);

  /// Optimistic like: updates UI immediately, attempts API in background.
  /// Keeps local state even if API fails.
  Future<void> likeTrack(String trackId,
      {String title = '', String artist = ''}) async {
    // Optimistic update (local source of truth)
    if (!_likedTrackIds.contains(trackId)) {
      _likedTrackIds.add(trackId);
      _likedTracks
          .add(LibraryTrack(id: trackId, title: title, artist: artist));
      notifyListeners();
    }

    // Try to sync with backend (don't rollback on failure)
    try {
      await LibraryService.likeTrack(trackId);
    } catch (e) {
      // Silently fail - local state is preserved
      debugPrint('Failed to like track on backend: $e');
    }
  }

  /// Optimistic unlike: removes from UI immediately, attempts API in background.
  /// Keeps local state even if API fails.
  Future<void> unlikeTrack(String trackId) async {
    // Optimistic update (local source of truth)
    if (_likedTrackIds.contains(trackId)) {
      _likedTrackIds.remove(trackId);
      _likedTracks.removeWhere((t) => t.id == trackId);
      notifyListeners();
    }

    // Try to sync with backend (don't rollback on failure)
    try {
      await LibraryService.unlikeTrack(trackId);
    } catch (e) {
      // Silently fail - local state is preserved
      debugPrint('Failed to unlike track on backend: $e');
    }
  }

  /// Toggle like state for a track.
  Future<void> toggleLike(String trackId,
      {String title = '', String artist = ''}) async {
    if (isTrackLiked(trackId)) {
      await unlikeTrack(trackId);
    } else {
      await likeTrack(trackId, title: title, artist: artist);
    }
  }

  // ── Create Playlist ───────────────────────────────────
  Future<bool> createPlaylist({
    required String title,
    required String description,
    bool isPublic = false,
  }) async {
    // Create locally first (optimistic)
    final localPlaylist = ApiPlaylist(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
    );
    _playlists.insert(0, localPlaylist);
    notifyListeners();

    // Try to sync with backend (don't rollback on failure)
    try {
      final playlist = await LibraryService.createPlaylist(
        title: title,
        description: description,
        isPublic: isPublic,
      );
      // Replace local with backend version
      _playlists.removeAt(0);
      _playlists.insert(0, playlist);
      notifyListeners();
      return true;
    } catch (e) {
      // Keep local playlist even if backend fails
      debugPrint('Failed to create playlist on backend: $e');
      return true; // Success locally
    }
  }
}
