import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/library_track.dart';
import '../providers/library_provider.dart';

/// A single track row with a like/unlike heart toggle.
class TrackItem extends StatelessWidget {
  final String trackId;
  final String title;
  final String artist;

  /// Optional trailing widget (e.g., more options).
  final Widget? trailing;

  const TrackItem({
    super.key,
    required this.trackId,
    required this.title,
    required this.artist,
    this.trailing,
  });

  /// Convenience constructor from a [LibraryTrack] model.
  factory TrackItem.fromLibraryTrack(LibraryTrack track, {Key? key}) {
    return TrackItem(
      key: key,
      trackId: track.id,
      title: track.title,
      artist: track.artist,
    );
  }

  @override
  Widget build(BuildContext context) {
    final libraryProvider = Provider.of<LibraryProvider>(context);
    final isLiked = libraryProvider.isTrackLiked(trackId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Music note icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.cardDark,
            ),
            child: const Center(
              child: Icon(
                Icons.music_note_rounded,
                color: AppColors.textHint,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title + Artist
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  artist,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Like toggle
          IconButton(
            onPressed: () {
              libraryProvider.toggleLike(
                trackId,
                title: title,
                artist: artist,
              );
            },
            icon: Icon(
              isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isLiked ? AppColors.primary : AppColors.textHint,
              size: 22,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
