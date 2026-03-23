import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/library_provider.dart';
import '../widgets/playlist_item.dart';
import '../widgets/track_item.dart';
import 'liked_songs_screen.dart';
import 'playlist_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Playlists', 'Recents'];
  bool _initialFetchDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialFetchDone) {
      _initialFetchDone = true;
      // Schedule on the event queue (after build + microtask phases)
      // so notifyListeners() never fires during a build.
      Future.delayed(Duration.zero, () {
        if (mounted) context.read<LibraryProvider>().fetchAll();
      });
    }
  }

  // ── Create-playlist modal ─────────────────────────────
  void _showCreatePlaylistDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
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
                'Create Playlist',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                style: const TextStyle(color: AppColors.textPrimary),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Description (optional)',
                  hintStyle: const TextStyle(color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final title = titleCtrl.text.trim();
                    if (title.isEmpty) return;

                    final success =
                        await context.read<LibraryProvider>().createPlaylist(
                              title: title,
                              description: descCtrl.text.trim(),
                            );

                    if (ctx.mounted) Navigator.pop(ctx);

                    if (!success && mounted) {
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
                    'Create Playlist',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LibraryProvider>(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/dhanur_logo.jpeg',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceLight,
                            child: const Icon(
                              Icons.person,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Your Library',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textPrimary,
                        size: 26,
                      ),
                    ),
                    IconButton(
                      onPressed: _showCreatePlaylistDialog,
                      icon: const Icon(
                        Icons.add_rounded,
                        color: AppColors.textPrimary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Filter chips ──────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedFilter == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textHint.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Content based on selected filter ─────────
            if (_selectedFilter == 0) ..._buildPlaylistsView(provider),
            if (_selectedFilter == 1) ..._buildRecentsView(provider),

            // Bottom spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 160 + bottomPadding),
            ),
          ],
        ),
      ),
    );
  }

  // ── Playlists tab ─────────────────────────────────────
  List<Widget> _buildPlaylistsView(LibraryProvider provider) {
    return [
      // Section header
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Row(
            children: [
              Icon(Icons.swap_vert_rounded,
                  color: AppColors.textSecondary, size: 18),
              SizedBox(width: 6),
              Text(
                'YOUR PLAYLISTS',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),

      // Liked Songs pseudo-playlist (always first)
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PlaylistItem(
            title: 'Liked Songs',
            subtitle:
                '📌 Playlist · ${provider.likedTracks.length} songs',
            leadingIcon: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF5B4FCF),
              ),
              child: const Center(
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LikedSongsScreen(),
                ),
              );
            },
          ),
        ),
      ),

      // Loading state
      if (provider.isLoadingPlaylists)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        ),

      // Error state
      if (provider.playlistsError != null)
        SliverToBoxAdapter(
          child: _buildErrorWidget(
            provider.playlistsError!,
            onRetry: provider.fetchPlaylists,
          ),
        ),

      // Playlists list
      if (!provider.isLoadingPlaylists && provider.playlistsError == null)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: provider.playlists.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No playlists yet. Tap + to create one!',
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 14),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final playlist = provider.playlists[index];
                      return PlaylistItem.fromApiPlaylist(
                        playlist,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PlaylistDetailScreen(playlist: playlist),
                            ),
                          );
                        },
                      );
                    },
                    childCount: provider.playlists.length,
                  ),
                ),
        ),
    ];
  }

  // ── Recents tab ───────────────────────────────────────
  List<Widget> _buildRecentsView(LibraryProvider provider) {
    return [
      // Section header
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.swap_vert_rounded,
                      color: AppColors.textSecondary, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'RECENTS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Icon(Icons.grid_view_rounded,
                  color: AppColors.textSecondary, size: 20),
            ],
          ),
        ),
      ),

      // Loading
      if (provider.isLoadingRecents)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        ),

      // Error
      if (provider.recentsError != null)
        SliverToBoxAdapter(
          child: _buildErrorWidget(
            provider.recentsError!,
            onRetry: provider.fetchRecentlyPlayed,
          ),
        ),

      // List
      if (!provider.isLoadingRecents && provider.recentsError == null)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: provider.recentlyPlayed.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No recently played tracks.',
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 14),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final track = provider.recentlyPlayed[index];
                      return TrackItem(
                        trackId: track.id,
                        title: track.title,
                        artist: track.artist,
                      );
                    },
                    childCount: provider.recentlyPlayed.length,
                  ),
                ),
        ),
    ];
  }

  // ── Error widget with retry ───────────────────────────
  Widget _buildErrorWidget(String message, {VoidCallback? onRetry}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.textHint, size: 40),
          const SizedBox(height: 8),
          Text(
            message,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry',
                  style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ],
      ),
    );
  }
}
