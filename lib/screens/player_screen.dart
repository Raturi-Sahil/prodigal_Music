import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/music_provider.dart';
import '../constants/app_colors.dart';

class PlayerScreen extends StatelessWidget {
  final Song song;

  const PlayerScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<MusicProvider>(
        builder: (context, musicProvider, child) {
          final isCurrentSong = musicProvider.currentSong?.title == song.title;
          final isPlaying = isCurrentSong && musicProvider.isPlaying;

          return Container(
            decoration: const BoxDecoration(
              gradient: AppColors.playerGradient,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top bar: down arrow + "DHANUR MUSIC" + menu
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textPrimary,
                            size: 32,
                          ),
                        ),
                        const Text(
                          'DHANUR MUSIC',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showOptionsSheet(context, song),
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Album Art (large, centered)
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 40,
                                  offset: const Offset(0, 20),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                song.coverImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.cardDark,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.music_note_rounded,
                                    color: AppColors.textHint,
                                    size: 100,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Song info + heart + add
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.title,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      song.artist,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      musicProvider.toggleLike(song.title);
                                    },
                                    child: Icon(
                                      musicProvider.isSongLiked(song.title)
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      color:
                                          musicProvider.isSongLiked(song.title)
                                              ? AppColors.primary
                                              : AppColors.textSecondary,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: AppColors.textSecondary,
                                    size: 26,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Progress bar
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.progressBackground,
                              thumbColor: AppColors.primary,
                              overlayColor: AppColors.primary.withOpacity(0.2),
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              trackHeight: 3,
                            ),
                            child: Slider(
                              value: isCurrentSong
                                  ? musicProvider.currentPosition.inSeconds
                                      .toDouble()
                                      .clamp(
                                          0,
                                          musicProvider.totalDuration.inSeconds
                                              .toDouble())
                                  : 0,
                              max: isCurrentSong &&
                                      musicProvider.totalDuration.inSeconds > 0
                                  ? musicProvider.totalDuration.inSeconds
                                      .toDouble()
                                  : 1,
                              onChanged: (value) {
                                musicProvider
                                    .seek(Duration(seconds: value.toInt()));
                              },
                            ),
                          ),

                          // Time labels
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(isCurrentSong
                                      ? musicProvider.currentPosition
                                      : Duration.zero),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _formatDuration(isCurrentSong
                                      ? musicProvider.totalDuration
                                      : (song.duration ?? Duration.zero)),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Controls: shuffle, prev, play/pause, next, repeat
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Shuffle
                              GestureDetector(
                                onTap: () => musicProvider.toggleShuffle(),
                                child: Icon(
                                  Icons.shuffle_rounded,
                                  color: musicProvider.isShuffleOn
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  size: 24,
                                ),
                              ),
                              // Previous
                              GestureDetector(
                                onTap: () => musicProvider.playPrevious(),
                                child: const Icon(
                                  Icons.skip_previous_rounded,
                                  color: AppColors.textPrimary,
                                  size: 38,
                                ),
                              ),
                              // Play / Pause (big white circle)
                              GestureDetector(
                                onTap: () {
                                  if (isCurrentSong) {
                                    if (isPlaying) {
                                      musicProvider.pause();
                                    } else {
                                      musicProvider.resume();
                                    }
                                  } else {
                                    musicProvider.playSong(song);
                                  }
                                },
                                child: Container(
                                  width: 68,
                                  height: 68,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.black,
                                    size: 38,
                                  ),
                                ),
                              ),
                              // Next
                              GestureDetector(
                                onTap: () => musicProvider.playNext(),
                                child: const Icon(
                                  Icons.skip_next_rounded,
                                  color: AppColors.textPrimary,
                                  size: 38,
                                ),
                              ),
                              // Repeat
                              GestureDetector(
                                onTap: () => musicProvider.toggleRepeat(),
                                child: Icon(
                                  Icons.repeat_rounded,
                                  color: musicProvider.isRepeatOn
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOptionsSheet(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Song info header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          song.coverImage,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 48,
                            height: 48,
                            color: AppColors.cardDark,
                            child: const Icon(Icons.music_note,
                                color: AppColors.textHint),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              song.artist,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: AppColors.surfaceLight,
                  height: 28,
                ),
                _buildSheetItem(Icons.playlist_add, 'Add to Playlist'),
                _buildSheetItem(Icons.share_rounded, 'Share'),
                _buildSheetItem(Icons.album_rounded, 'View Album'),
                _buildSheetItem(Icons.person_rounded, 'View Artist'),
                _buildSheetItem(Icons.lyrics_rounded, 'View Lyrics'),
                _buildSheetItem(Icons.info_outline_rounded, 'Song Info'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: () {},
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
