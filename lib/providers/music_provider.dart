import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';
import '../data/songs_data.dart';
import '../main.dart' show audioHandler;

class MusicProvider extends ChangeNotifier {
  // Fallback player only used if audio_service fails to init
  AudioPlayer? _fallbackPlayer;

  Song? _currentSong;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isShuffleOn = false;
  bool _isRepeatOn = false;
  final Set<String> _likedSongs = {};
  int _currentIndex = -1;
  DateTime _lastPositionNotify = DateTime.now();

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isShuffleOn => _isShuffleOn;
  bool get isRepeatOn => _isRepeatOn;
  Set<String> get likedSongs => _likedSongs;
  int get currentIndex => _currentIndex;

  List<Song> get allSongs => SongsData.getAllSongs();

  /// Returns the handler's player if audio_service initialized, otherwise a fallback
  AudioPlayer get _player {
    if (audioHandler != null) return audioHandler!.player;
    _fallbackPlayer ??= AudioPlayer();
    return _fallbackPlayer!;
  }

  MusicProvider() {
    // Defer listener setup to let audio_service init complete
    Future.delayed(const Duration(seconds: 3), _setupListeners);
  }

  void _setupListeners() {
    final player = _player;

    player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    player.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    player.onPositionChanged.listen((position) {
      _currentPosition = position;
      final now = DateTime.now();
      if (now.difference(_lastPositionNotify).inMilliseconds > 500) {
        _lastPositionNotify = now;
        notifyListeners();
      }
    });

    player.onPlayerComplete.listen((_) {
      if (_isRepeatOn) {
        if (_currentSong != null) {
          _playCurrent();
        }
      } else {
        playNext();
      }
    });

    // Setup notification skip callbacks
    final handler = audioHandler;
    if (handler != null) {
      handler.onSkipToNext = () async => await playNext();
      handler.onSkipToPrevious = () async => await playPrevious();
    }
  }

  Future<void> _playCurrent() async {
    if (_currentSong == null) return;
    final assetPath = _currentSong!.audioPath.replaceFirst('assets/', '');
    audioHandler?.setCurrentMediaItem(
      title: _currentSong!.title,
      artist: _currentSong!.artist,
    );
    if (audioHandler != null) {
      await audioHandler!.playFromAsset(assetPath);
    } else {
      await _player.play(AssetSource(assetPath));
    }
    notifyListeners();
  }

  Future<void> playSong(Song song, {bool forcePlay = false}) async {
    if (!forcePlay && _currentSong?.title == song.title && _isPlaying) {
      await pause();
    } else {
      _currentSong = song;
      _currentIndex = allSongs.indexWhere((s) => s.title == song.title);
      final assetPath = song.audioPath.replaceFirst('assets/', '');
      audioHandler?.setCurrentMediaItem(
        title: song.title,
        artist: song.artist,
      );
      if (audioHandler != null) {
        await audioHandler!.playFromAsset(assetPath);
      } else {
        await _player.play(AssetSource(assetPath));
      }
      notifyListeners();
    }
  }

  Future<void> pause() async {
    if (audioHandler != null) {
      await audioHandler!.pause();
    } else {
      await _player.pause();
    }
  }

  Future<void> resume() async {
    if (audioHandler != null) {
      await audioHandler!.play();
    } else {
      await _player.resume();
    }
  }

  Future<void> seek(Duration position) async {
    if (audioHandler != null) {
      await audioHandler!.seek(position);
    } else {
      await _player.seek(position);
    }
  }

  void toggleShuffle() {
    _isShuffleOn = !_isShuffleOn;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeatOn = !_isRepeatOn;
    notifyListeners();
  }

  void toggleLike(String songTitle) {
    if (_likedSongs.contains(songTitle)) {
      _likedSongs.remove(songTitle);
    } else {
      _likedSongs.add(songTitle);
    }
    notifyListeners();
  }

  bool isSongLiked(String songTitle) {
    return _likedSongs.contains(songTitle);
  }

  Future<void> playNext() async {
    final songs = allSongs;
    if (songs.isEmpty) return;

    if (_isShuffleOn) {
      final randomIndex = (songs.length > 1)
          ? (DateTime.now().millisecondsSinceEpoch % songs.length)
          : 0;
      await playSong(songs[randomIndex], forcePlay: true);
    } else {
      _currentIndex = (_currentIndex + 1) % songs.length;
      await playSong(songs[_currentIndex], forcePlay: true);
    }
  }

  Future<void> playPrevious() async {
    final songs = allSongs;
    if (songs.isEmpty) return;

    if (_currentPosition.inSeconds > 3) {
      await seek(Duration.zero);
    } else {
      _currentIndex = (_currentIndex - 1 + songs.length) % songs.length;
      await playSong(songs[_currentIndex], forcePlay: true);
    }
  }

  @override
  void dispose() {
    _fallbackPlayer?.dispose();
    super.dispose();
  }
}
