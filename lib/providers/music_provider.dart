import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';
import '../data/songs_data.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Song? _currentSong;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isShuffleOn = false;
  bool _isRepeatOn = false;
  final Set<String> _likedSongs = {};
  int _currentIndex = -1;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isShuffleOn => _isShuffleOn;
  bool get isRepeatOn => _isRepeatOn;
  Set<String> get likedSongs => _likedSongs;
  int get currentIndex => _currentIndex;

  List<Song> get allSongs => SongsData.getAllSongs();

  MusicProvider() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (_isRepeatOn) {
        // Replay current song
        if (_currentSong != null) {
          _audioPlayer.play(
            AssetSource(_currentSong!.audioPath.replaceFirst('assets/', '')),
          );
        }
      } else {
        playNext();
      }
    });
  }

  Future<void> playSong(Song song) async {
    if (_currentSong?.title == song.title && _isPlaying) {
      await pause();
    } else {
      _currentSong = song;
      _currentIndex = allSongs.indexWhere((s) => s.title == song.title);
      await _audioPlayer.play(
        AssetSource(song.audioPath.replaceFirst('assets/', '')),
      );
      notifyListeners();
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
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
      // Play random song
      final randomIndex = (songs.length > 1)
          ? (DateTime.now().millisecondsSinceEpoch % songs.length)
          : 0;
      await playSong(songs[randomIndex]);
    } else {
      _currentIndex = (_currentIndex + 1) % songs.length;
      await playSong(songs[_currentIndex]);
    }
  }

  Future<void> playPrevious() async {
    final songs = allSongs;
    if (songs.isEmpty) return;

    if (_currentPosition.inSeconds > 3) {
      // If more than 3 seconds in, restart current song
      await seek(Duration.zero);
    } else {
      _currentIndex = (_currentIndex - 1 + songs.length) % songs.length;
      await playSong(songs[_currentIndex]);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
