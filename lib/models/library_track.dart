/// A track from the user's liked-songs library (`GET /v1/library`).
class LibraryTrack {
  final String id;
  final String title;
  final String artist;

  const LibraryTrack({
    required this.id,
    required this.title,
    required this.artist,
  });

  factory LibraryTrack.fromJson(Map<String, dynamic> json) {
    return LibraryTrack(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
    );
  }
}
