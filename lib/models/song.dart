class Song {
  final String id;
  final String title;
  final String artist;
  final String genre;
  final String description;
  final String lyrics;
  final String coverImage;
  final String audioPath;
  final String? albumName;
  final Duration? duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.description,
    required this.lyrics,
    required this.coverImage,
    required this.audioPath,
    this.albumName,
    this.duration,
  });
}

class Playlist {
  final String name;
  final String coverImage;
  final String subtitle;
  final List<Song> songs;
  final bool isPinned;

  Playlist({
    required this.name,
    required this.coverImage,
    required this.subtitle,
    this.songs = const [],
    this.isPinned = false,
  });
}

class Genre {
  final String name;
  final int colorValue;

  Genre({required this.name, required this.colorValue});
}
