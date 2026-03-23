import '../models/song.dart';

class SongsData {
  static List<Song> getAllSongs() {
    return [
      Song(
        id: 'track_ashes_of_crown_001',
        title: 'Ashes of the Crown',
        artist: 'Metal Legends',
        genre: 'Metal',
        albumName: 'The Sonic Frontier',
        coverImage:
            'assets/images/WhatsApp Image 2026-03-07 at 3.06.31 PM.jpeg',
        audioPath: 'assets/images/Ashes of the Crown.mp3.mpeg',
        duration: const Duration(minutes: 3, seconds: 55),
        description:
            '''This song tells the story of a fallen ruler betrayed from within. Once surrounded by loyalty and power, the protagonist realizes the throne was rotting long before it collapsed. Trusted allies turned venomous. Smiles masked sabotage. The crown — once a symbol of authority — became a trap.

The fall wasn't sudden. It was orchestrated. Bridges were burned, identity was stripped away, and silence was expected in defeat. The enemies believed they had buried him for good.

But betrayal becomes fuel. Every lie becomes armor. Every scar becomes proof of survival. The fire meant to destroy instead reforges him into something stronger — not a king by title, but a force by will.

The breakdown marks the turning point: no more submission, no more crawling. The fallen ruler rises not to reclaim the old throne — but to become something beyond it.

By the end, he no longer needs a crown. He is the crown. Not restored — reborn. Not forgiven — unbreakable.

This is a metal anthem about resilience, revenge, and reclaiming power from those who tried to erase you.''',
        lyrics: '''[Verse 1]
Rust on my throne
Blood in my wine
Snakes at the table
Calling it "divine"
Burned every bridge
Smiled while I drowned
Tore off my banner
Ripped out the crown

[Pre-Chorus]
But you taught me
Every sharpened lie
Now I wear them
Like armor on my spine

[Chorus]
From the ashes of the crown I rise
Hear the broken
Turning into knives
Every scar a banner in the sky
I will not kneel
I will not die
From the ashes of the crown I rise (rise!)
From the ashes of the crown I rise

[Verse 2]
Glass in my hands
Thorns in my bed
Carved up my future
Fed on my dread
Buried my name
Deep in the ground
Thought I'd stay silent
You're hearing me now

[Pre-Chorus]
You lit the fire
Thinking I would fade
Now I'm walking
Through everything you made

[Chorus]
From the ashes of the crown I rise
Hear the broken
Turning into knives
Every scar a banner in the sky
I will not kneel
I will not die
From the ashes of the crown I rise (rise!)
From the ashes of the crown I rise

[Breakdown]
You want a king?
Then watch me stand
Fist to the flame
Steel in my hands
You want me gone?
Then draw that line

[Chant]
I!
Refuse!
To crawl!
This time!
I!
Refuse!
To crawl!
This time!

[Breakdown]
Bite through the chains
Spit out the rust
Grind down your throne
Turn it to dust (hey!)

[Instrumental]
[Explosive guitar solo over marching
Ascending progression]

[Chorus]
From the ashes of the crown I rise
Hear the broken
Turning into knives
Every scar a banner in the sky
I will not kneel
I will not die
From the ashes of the crown I rise (rise!)
From the ashes of the crown I rise

[Outro]
Bow if you want
I'll never bend
I am the storm
I am the end
From the ashes
Say it out loud—
I wear the fire
I am the crown''',
      ),
    ];
  }

  // Dummy playlists for the library / home screen
  static List<Playlist> getPlaylists() {
    return [
      Playlist(
        name: 'Liked Songs',
        coverImage: '',
        subtitle: '📌 Playlist · 248 songs',
        isPinned: true,
      ),
      Playlist(
        name: 'Dhanur Mix',
        coverImage: 'assets/images/dhanur_logo.jpeg',
        subtitle: 'Playlist · Dhanur Music',
      ),
      Playlist(
        name: 'Deep Focus',
        coverImage: 'assets/images/dhanur_logo.jpeg',
        subtitle: 'Album · Various Artists',
      ),
      Playlist(
        name: 'Morning Acoustic',
        coverImage: 'assets/images/dhanur_logo.jpeg',
        subtitle: 'Playlist · Dhanur Music',
      ),
      Playlist(
        name: 'Jazz After Hours',
        coverImage: 'assets/images/dhanur_logo.jpeg',
        subtitle: 'Playlist · Curator Name',
      ),
      Playlist(
        name: 'Electronic Beats',
        coverImage: 'assets/images/dhanur_logo.jpeg',
        subtitle: 'Album · Synth Wave',
      ),
    ];
  }

  // Recently played items for home
  static List<Map<String, String>> getRecentlyPlayed() {
    return [
      {'name': 'Lofi Beats', 'image': 'assets/images/dhanur_logo.jpeg'},
      {'name': 'Chill Mix', 'image': 'assets/images/dhanur_logo.jpeg'},
      {'name': 'Dhanur Daily', 'image': 'assets/images/dhanur_logo.jpeg'},
      {'name': 'Classic Jams', 'image': 'assets/images/dhanur_logo.jpeg'},
      {'name': 'Deep Focus', 'image': 'assets/images/dhanur_logo.jpeg'},
      {'name': 'Morning Run', 'image': 'assets/images/dhanur_logo.jpeg'},
    ];
  }

  // Recommended albums for home
  static List<Map<String, String>> getRecommended() {
    return [
      {
        'name': 'Pulse of Tomorrow',
        'artist': 'AI Generated · Electronic',
        'image': 'assets/images/dhanur_logo.jpeg',
      },
      {
        'name': 'Oceanic Dreams',
        'artist': 'The AI Collective · Ambient',
        'image': 'assets/images/dhanur_logo.jpeg',
      },
      {
        'name': 'Forest Echoes',
        'artist': 'Neural Sounds · Nature',
        'image': 'assets/images/dhanur_logo.jpeg',
      },
      {
        'name': 'Midnight City',
        'artist': 'The Echoes · Synth',
        'image': 'assets/images/dhanur_logo.jpeg',
      },
    ];
  }

  // Genre list for search
  static List<Map<String, dynamic>> getGenres() {
    return [
      {'name': 'Lo-Fi', 'color': 0xFF8B5CF6},
      {'name': 'EDM', 'color': 0xFF14B8A6},
      {'name': 'Focus', 'color': 0xFFFF6B35},
      {'name': 'Chill', 'color': 0xFF3B82F6},
      {'name': 'Rock', 'color': 0xFFEF4444},
      {'name': 'Pop', 'color': 0xFFF59E0B},
      {'name': 'Podcasts', 'color': 0xFF14B8A6},
      {'name': 'New Releases', 'color': 0xFFEC4899},
      {'name': 'Metal', 'color': 0xFF6B21A8},
      {'name': 'Jazz', 'color': 0xFF0284C7},
      {'name': 'Classical', 'color': 0xFF9333EA},
      {'name': 'Acoustic', 'color': 0xFF65A30D},
    ];
  }

  // Trending genre tags for home
  static List<String> getTrendingGenres() {
    return [
      'Neuro-Soul',
      'Synth-Folk',
      'Algorithmic Jazz',
      'Lo-Fi',
      'Ambient',
    ];
  }
}
