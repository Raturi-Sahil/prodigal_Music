import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> Function()? onSkipToNext;
  Future<void> Function()? onSkipToPrevious;

  AudioPlayerHandler() {
    AudioPlayer.global.setAudioContext(AudioContextConfig(
      respectSilence: false,
      stayAwake: true,
    ).build());

    _player.onPlayerStateChanged.listen((state) {
      final playing = state == PlayerState.playing;
      playbackState.add(playbackState.value.copyWith(
        playing: playing,
        processingState: AudioProcessingState.ready,
      ));
    });

    _player.onDurationChanged.listen((duration) {
      final item = mediaItem.value;
      if (item != null) {
        mediaItem.add(item.copyWith(duration: duration));
      }
    });

    _player.onPositionChanged.listen((position) {
      playbackState.add(playbackState.value.copyWith(
        updatePosition: position,
      ));
    });
  }

  void setCurrentMediaItem({
    required String title,
    required String artist,
    String? artUri,
  }) {
    mediaItem.add(MediaItem(
      id: title,
      title: title,
      artist: artist,
      artUri: artUri != null ? Uri.parse(artUri) : null,
    ));
  }

  PlaybackState _transformState({
    required bool playing,
    AudioProcessingState processingState = AudioProcessingState.ready,
    Duration position = Duration.zero,
  }) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: processingState,
      playing: playing,
      updatePosition: position,
    );
  }

  Future<void> playFromAsset(String assetPath) async {
    playbackState.add(_transformState(
      playing: true,
      processingState: AudioProcessingState.loading,
    ));
    await _player.play(AssetSource(assetPath));
    playbackState.add(_transformState(playing: true));
  }

  @override
  Future<void> play() async {
    await _player.resume();
    playbackState.add(_transformState(
      playing: true,
      position: playbackState.value.updatePosition,
    ));
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    playbackState.add(_transformState(
      playing: false,
      position: playbackState.value.updatePosition,
    ));
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    playbackState.add(playbackState.value.copyWith(
      updatePosition: position,
    ));
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(_transformState(
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
    await super.stop();
  }

  @override
  Future<void> skipToNext() async {
    await onSkipToNext?.call();
  }

  @override
  Future<void> skipToPrevious() async {
    await onSkipToPrevious?.call();
  }
}
