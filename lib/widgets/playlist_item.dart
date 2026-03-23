import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/api_playlist.dart';

/// A single playlist row tile for the library list.
class PlaylistItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? leadingIcon;

  const PlaylistItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.leadingIcon,
  });

  /// Convenience: build from an [ApiPlaylist].
  factory PlaylistItem.fromApiPlaylist(
    ApiPlaylist playlist, {
    Key? key,
    VoidCallback? onTap,
  }) {
    return PlaylistItem(
      key: key,
      title: playlist.title,
      subtitle: playlist.description,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            // Cover / icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.cardDark,
              ),
              child: leadingIcon ??
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/dhanur_logo.jpeg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.cardDark,
                        child: const Icon(
                          Icons.queue_music_rounded,
                          color: AppColors.textHint,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
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
          ],
        ),
      ),
    );
  }
}
