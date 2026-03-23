/// A track from the recently-played endpoint (`GET /v1/recently-played`).
class RecentlyPlayedTrack {
  final String id;
  final String title;
  final String artist;
  final DateTime playedAt;

  const RecentlyPlayedTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.playedAt,
  });

  factory RecentlyPlayedTrack.fromJson(Map<String, dynamic> json) {
    return RecentlyPlayedTrack(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      playedAt: DateTime.parse(json['played_at'] as String),
    );
  }
}
