import 'package:audio_verse/services/favorites_service.dart';
import 'package:flutter/material.dart';
import 'package:audio_verse/models/user.dart';
import 'package:audio_verse/services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audio_verse/models/audiobook.dart';
import 'package:provider/provider.dart';
import 'package:audio_verse/providers/audio_player_provider.dart'; // Import the AudioPlayerProvider

class AudiobookDetailsScreen extends StatefulWidget {
  final Audiobook audiobook;

  const AudiobookDetailsScreen({Key? key, required this.audiobook})
      : super(key: key);

  @override
  _AudiobookDetailsScreenState createState() => _AudiobookDetailsScreenState();
}

class _AudiobookDetailsScreenState extends State<AudiobookDetailsScreen> {
  late AudioPlayerProvider
      _audioPlayerProvider; // Declare the AudioPlayerProvider

  late MyAppUser _currentUser;
  final FavoritesService _favoritesService = FavoritesService();
  String? audiobookCoverImageUrl;
  String? audiobookAudioFileUrl;
  bool isPlaying = false;
  double playbackSpeed = 1.0;
  Duration? _duration;
  Duration? _position;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _loadAudiobookCoverImage();
    _loadAudiobookAudioFile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    _audioPlayerProvider.addListener(_audioPlayerListener);
    _audioPlayerProvider.initListeners();
  }

  void _audioPlayerListener() {
    setState(() {
      isPlaying = _audioPlayerProvider.isPlaying;
      _duration = _audioPlayerProvider.duration;
      _position = _audioPlayerProvider.position;
    });
  }

  Future<void> _loadAudiobookCoverImage() async {
    try {
      DocumentSnapshot audiobookSnapshot = await FirebaseFirestore.instance
          .collection('audiobooks')
          .doc(widget.audiobook.id)
          .get();

      setState(() {
        audiobookCoverImageUrl = audiobookSnapshot['coverImageUrl'];
      });
    } catch (e) {
      print('Error loading audiobook cover image: $e');
    }
  }

  Future<void> _loadAudiobookAudioFile() async {
    try {
      DocumentSnapshot audiobookSnapshot = await FirebaseFirestore.instance
          .collection('audiobooks')
          .doc(widget.audiobook.id)
          .get();

      setState(() {
        audiobookAudioFileUrl = audiobookSnapshot['audioFileUrl'];
      });
    } catch (e) {
      print('Error loading audiobook audio file: $e');
    }
  }

  Future<void> _getCurrentUser() async {
    MyAppUser? currentUser = await AuthenticationService().getCurrentUser();
    setState(() {
      _currentUser = currentUser!;
    });
  }

  @override
  void dispose() {
    _audioPlayerProvider.removeListener(_audioPlayerListener);
    super.dispose();
  }

  Future<void> _toggleBookmark() async {
    List<Audiobook> bookmarks =
        await _favoritesService.getBookmarks(_currentUser.uid);
    bool isBookmarked = bookmarks.any((book) => book.id == widget.audiobook.id);

    if (isBookmarked) {
      await _favoritesService.removeBookmark(
          _currentUser.uid, widget.audiobook);
    } else {
      await _favoritesService.addBookmark(_currentUser.uid, widget.audiobook);
    }
  }

  Future<void> _togglePlayback() async {
    if (isPlaying) {
      await _audioPlayerProvider.pause();
    } else {
      try {
        await _audioPlayerProvider.play(audiobookAudioFileUrl!);
      } catch (e) {
        print('Error playing audiobook: $e');
      }
    }
  }

  Future<void> _seekTo(Duration position) async {
    await _audioPlayerProvider.seek(position);
  }

  Future<void> _changePlaybackSpeed(double speed) async {
    await _audioPlayerProvider.changeSpeed(speed);
  }

  String getFormattedDuration(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audiobook Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (audiobookCoverImageUrl != null)
                Image.network(audiobookCoverImageUrl!),
              const SizedBox(height: 16.0),
              Text(
                widget.audiobook.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.audiobook.author,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (audiobookAudioFileUrl != null) {
                    await _togglePlayback();
                  }
                },
                child: Text(isPlaying ? 'Pause' : 'Play'),
              ),
              const SizedBox(height: 16.0),
              if (_duration != null)
                Column(
                  children: [
                    Text(
                      'Total Length: ${getFormattedDuration(_duration!)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    Slider(
                      value: _position?.inSeconds.toDouble() ?? 0.0,
                      onChanged: (value) {
                        _seekTo(Duration(seconds: value.toInt()));
                      },
                      max: _duration?.inSeconds.toDouble() ?? 0.0,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Current Position: ${getFormattedDuration(_position ?? Duration.zero)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _changePlaybackSpeed(1.0);
                    },
                    child: Text('1x'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _changePlaybackSpeed(1.5);
                    },
                    child: Text('1.5x'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _changePlaybackSpeed(2.0);
                    },
                    child: Text('2x'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _toggleBookmark();
                },
                child: Text('Toggle Bookmark'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
