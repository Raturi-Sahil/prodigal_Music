import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../data/songs_data.dart';
import '../models/song.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final Set<String> _likedSongs = {};

  late final List<Song> _allSongs;
  late final Future<void> _setupFuture;

  Song? _currentSong;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isShuffleOn = false;
  bool _isRepeatOn = false;
  int _currentIndex = -1;
  bool _isDisposed = false;
  bool _hasSelectedSong = false;
  bool _isPlayerReady = false;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isShuffleOn => _isShuffleOn;
  bool get isRepeatOn => _isRepeatOn;
  Set<String> get likedSongs => _likedSongs;
  int get currentIndex => _currentIndex;
  List<Song> get allSongs => List.unmodifiable(_allSongs);

  MusicProvider() {
    _allSongs = SongsData.getAllSongs();
    _attachListeners();
    _setupFuture = _configureAudioSession();
  }

  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  void _attachListeners() {
    _subscriptions.add(
      _audioPlayer.playerStateStream.listen((state) {
        _isPlaying = state.playing;
        _notifyListenersSafely();
      }),
    );

    _subscriptions.add(
      _audioPlayer.durationStream.listen((duration) {
        _totalDuration = duration ?? _currentSong?.duration ?? Duration.zero;
        _notifyListenersSafely();
      }),
    );

    _subscriptions.add(
      _audioPlayer.positionStream.listen((position) {
        _currentPosition = position;
        _notifyListenersSafely();
      }),
    );

    _subscriptions.add(
      _audioPlayer.currentIndexStream.listen((index) {
        if (index == null) {
          return;
        }

        _currentIndex = index;
        if (_hasSelectedSong && index >= 0 && index < _allSongs.length) {
          _currentSong = _allSongs[index];
          _totalDuration =
              _audioPlayer.duration ?? _currentSong?.duration ?? Duration.zero;
        }
        _notifyListenersSafely();
      }),
    );

    _subscriptions.add(
      _audioPlayer.shuffleModeEnabledStream.listen((enabled) {
        _isShuffleOn = enabled;
        _notifyListenersSafely();
      }),
    );

    _subscriptions.add(
      _audioPlayer.loopModeStream.listen((loopMode) {
        _isRepeatOn = loopMode == LoopMode.one;
        _notifyListenersSafely();
      }),
    );
  }

  Future<void> _ensurePlayerReady() async {
    await _setupFuture;
    if (_isPlayerReady || _allSongs.isEmpty) {
      return;
    }

    await _audioPlayer.setAudioSources(
      _allSongs.map(_buildAudioSource).toList(),
      preload: true,
    );
    await _syncPlayerModes();
    _isPlayerReady = true;
  }

  AudioSource _buildAudioSource(Song song) {
    return AudioSource.uri(
      Uri.parse(Uri.encodeFull('asset:///${song.audioPath}')),
      tag: MediaItem(
        id: '${song.title}-${song.artist}',
        album: song.albumName ?? 'Dhanur Music',
        title: song.title,
        artist: song.artist,
        duration: song.duration,
      ),
    );
  }

  Future<void> _syncPlayerModes() async {
    await _audioPlayer.setLoopMode(_isRepeatOn ? LoopMode.one : LoopMode.all);
    if (_isShuffleOn) {
      await _audioPlayer.shuffle();
    }
    await _audioPlayer.setShuffleModeEnabled(_isShuffleOn);
  }

  int _indexForSong(Song song) {
    return _allSongs.indexWhere(
      (candidate) =>
          candidate.audioPath == song.audioPath &&
          candidate.title == song.title &&
          candidate.artist == song.artist,
    );
  }

  Future<void> playSong(Song song, {bool forcePlay = false}) async {
    final index = _indexForSong(song);
    if (index < 0) {
      return;
    }

    await _ensurePlayerReady();

    if (!forcePlay &&
        _hasSelectedSong &&
        _currentIndex == index &&
        _isPlaying) {
      await pause();
      return;
    }

    _hasSelectedSong = true;
    _currentSong = song;
    _currentIndex = index;
    _currentPosition = Duration.zero;
    _totalDuration = song.duration ?? Duration.zero;
    _notifyListenersSafely();

    await _audioPlayer.seek(Duration.zero, index: index);
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    if (_allSongs.isEmpty) {
      return;
    }

    await _ensurePlayerReady();

    final index = _currentIndex >= 0 ? _currentIndex : 0;
    if (!_hasSelectedSong) {
      _hasSelectedSong = true;
      _currentSong = _allSongs[index];
      _currentIndex = index;
      _totalDuration = _currentSong?.duration ?? Duration.zero;
      _notifyListenersSafely();
    }

    if (_audioPlayer.processingState == ProcessingState.completed) {
      await _audioPlayer.seek(Duration.zero, index: index);
    }

    await _audioPlayer.play();
  }

  Future<void> seek(Duration position) async {
    if (!_hasSelectedSong) {
      return;
    }
    await _audioPlayer.seek(position);
  }

  void toggleShuffle() {
    _isShuffleOn = !_isShuffleOn;
    _notifyListenersSafely();
    unawaited(_applyShuffleMode());
  }

  Future<void> _applyShuffleMode() async {
    if (!_isPlayerReady) {
      return;
    }

    if (_isShuffleOn) {
      await _audioPlayer.shuffle();
    }
    await _audioPlayer.setShuffleModeEnabled(_isShuffleOn);
  }

  void toggleRepeat() {
    _isRepeatOn = !_isRepeatOn;
    _notifyListenersSafely();
    unawaited(_applyLoopMode());
  }

  Future<void> _applyLoopMode() async {
    if (!_isPlayerReady) {
      return;
    }
    await _audioPlayer.setLoopMode(_isRepeatOn ? LoopMode.one : LoopMode.all);
  }

  void toggleLike(String songTitle) {
    if (_likedSongs.contains(songTitle)) {
      _likedSongs.remove(songTitle);
    } else {
      _likedSongs.add(songTitle);
    }
    _notifyListenersSafely();
  }

  bool isSongLiked(String songTitle) {
    return _likedSongs.contains(songTitle);
  }

  Future<void> playNext() async {
    if (_allSongs.isEmpty) {
      return;
    }

    await _ensurePlayerReady();

    if (!_hasSelectedSong) {
      await playSong(_allSongs.first, forcePlay: true);
      return;
    }

    if (_audioPlayer.hasNext) {
      await _audioPlayer.seekToNext();
      await _audioPlayer.play();
      return;
    }

    await _audioPlayer.seek(Duration.zero, index: 0);
    await _audioPlayer.play();
  }

  Future<void> playPrevious() async {
    if (_allSongs.isEmpty) {
      return;
    }

    await _ensurePlayerReady();

    if (!_hasSelectedSong) {
      await playSong(_allSongs.first, forcePlay: true);
      return;
    }

    if (_currentPosition.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }

    if (_audioPlayer.hasPrevious) {
      await _audioPlayer.seekToPrevious();
      await _audioPlayer.play();
      return;
    }

    final lastIndex = _allSongs.length - 1;
    await _audioPlayer.seek(Duration.zero, index: lastIndex);
    await _audioPlayer.play();
  }

  void _notifyListenersSafely() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _audioPlayer.dispose();
    super.dispose();
  }
}
