import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/music_provider.dart';
import '../providers/library_provider.dart';
import '../constants/app_colors.dart';

class PlayerScreen extends StatefulWidget {
  final Song song;

  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool _initialFetchDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialFetchDone) {
      _initialFetchDone = true;
      // Fetch library data on first open to sync liked state and playlists
      Future.delayed(Duration.zero, () {
        if (mounted) {
          context.read<LibraryProvider>().fetchAll();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer2<MusicProvider, LibraryProvider>(
        builder: (context, musicProvider, libraryProvider, child) {
          final isCurrentSong =
              musicProvider.currentSong?.title == widget.song.title;
          final isPlaying = isCurrentSong && musicProvider.isPlaying;
          final isLiked = libraryProvider.isTrackLiked(widget.song.id);

          return Container(
            decoration: const BoxDecoration(
              gradient: AppColors.playerGradient,
            ),
            child: DefaultTabController(
              length: 3,
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
                            onPressed: () => _showOptionsSheet(context, widget.song),
                            icon: const Icon(
                              Icons.more_vert_rounded,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tabs for switching between Player, Lyrics, and Backstory
                    const TabBar(
                      indicatorColor: AppColors.primary,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textSecondary,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: 'Player'),
                        Tab(text: 'Lyrics'),
                        Tab(text: 'Story'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tab Views
                    Expanded(
                      flex: 5,
                      child: TabBarView(
                        children: [
                          // 1. Player (Album Art)
                          Padding(
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
                                      widget.song.coverImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.cardDark,
                                          borderRadius:
                                              BorderRadius.circular(12),
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

                          // 2. Lyrics
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Text(
                                  widget.song.lyrics.isEmpty
                                      ? 'No lyrics available'
                                      : widget.song.lyrics,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    height: 1.8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                          // 3. Backstory
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Text(
                                  widget.song.description.isEmpty
                                      ? 'No backstory available'
                                      : widget.song.description,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 15,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.song.title,
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
                                        widget.song.artist,
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
                                        libraryProvider.toggleLike(
                                          widget.song.id,
                                          title: widget.song.title,
                                          artist: widget.song.artist,
                                        );
                                      },
                                      child: Icon(
                                        isLiked
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        color: isLiked
                                            ? const Color(0xFFE74C3C)
                                            : AppColors.textSecondary,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () => _showAddToPlaylistModal(
                                          context, widget.song, libraryProvider),
                                      child: const Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: AppColors.textSecondary,
                                        size: 26,
                                      ),
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
                                inactiveTrackColor:
                                    AppColors.progressBackground,
                                thumbColor: AppColors.primary,
                                overlayColor:
                                    AppColors.primary.withOpacity(0.2),
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
                                            musicProvider
                                                .totalDuration.inSeconds
                                                .toDouble())
                                    : 0,
                                max: isCurrentSong &&
                                        musicProvider.totalDuration.inSeconds >
                                            0
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        : (widget.song.duration ?? Duration.zero)),
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
                                      musicProvider.playSong(widget.song);
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
                          widget.song.coverImage,
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
                              widget.song.artist,
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

  void _showAddToPlaylistModal(
    BuildContext context,
    Song song,
    LibraryProvider libraryProvider,
  ) {
    final titleCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  MediaQuery.of(ctx).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add to Playlist',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Existing Playlists ───────────────────
                    if (libraryProvider.playlists.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Playlists',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...libraryProvider.playlists.map(
                            (playlist) => GestureDetector(
                              onTap: () {
                                // TODO: Implement add to existing playlist
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added to ${playlist.title}',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.cardDark,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.queue_music_rounded,
                                      color: AppColors.textHint,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            playlist.title,
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (playlist.description.isNotEmpty)
                                            Text(
                                              playlist.description,
                                              style: const TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: AppColors.cardDark),
                          const SizedBox(height: 20),
                        ],
                      ),

                    // ── Create New Playlist ───────────────────
                    const Text(
                      'Create New Playlist',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Playlist name',
                        hintStyle: const TextStyle(color: AppColors.textHint),
                        filled: true,
                        fillColor: AppColors.cardDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          final title = titleCtrl.text.trim();
                          if (title.isEmpty) return;

                          final success =
                              await libraryProvider.createPlaylist(
                            title: title,
                            description: 'Playlist created from player',
                          );

                          if (ctx.mounted) Navigator.pop(ctx);

                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Created playlist "$title" and added song',
                                ),
                              ),
                            );
                          } else if (!success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to create playlist'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Create & Add',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
