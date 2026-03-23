import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/library_provider.dart';
import '../widgets/track_item.dart';

/// Screen listing all liked tracks from the user's library.
class LikedSongsScreen extends StatelessWidget {
  const LikedSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LibraryProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B4FCF),
        title: const Text('Liked Songs'),
        centerTitle: true,
      ),
      body: provider.isLoadingLibrary
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : provider.libraryError != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.textHint, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        provider.libraryError!,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: provider.fetchLibrary,
                        child: const Text('Retry',
                            style: TextStyle(color: AppColors.primary)),
                      ),
                    ],
                  ),
                )
              : provider.likedTracks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite_border_rounded,
                              color: AppColors.textHint, size: 48),
                          SizedBox(height: 12),
                          Text(
                            'Songs you like will appear here',
                            style: TextStyle(
                                color: AppColors.textHint, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: provider.likedTracks.length,
                      itemBuilder: (context, index) {
                        return TrackItem.fromLibraryTrack(
                          provider.likedTracks[index],
                        );
                      },
                    ),
    );
  }
}
