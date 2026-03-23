/// A playlist from the user's playlists endpoint (`GET /v1/playlists`).
class ApiPlaylist {
  final String id;
  final String title;
  final String description;

  const ApiPlaylist({
    required this.id,
    required this.title,
    required this.description,
  });

  factory ApiPlaylist.fromJson(Map<String, dynamic> json) {
    return ApiPlaylist(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
