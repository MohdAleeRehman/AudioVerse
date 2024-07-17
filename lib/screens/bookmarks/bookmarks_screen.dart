import 'package:audio_verse/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_verse/providers/audio_player_provider.dart';
import 'package:audio_verse/models/audiobook.dart';
import 'package:audio_verse/services/favorites_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarksScreen extends StatefulWidget {
  final MyAppUser user;

  const BookmarksScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final FavoritesService favoritesService = FavoritesService();
  late List<Audiobook> bookmarks;
  late AudioPlayerProvider audioPlayerProvider;
  String? audiobookCoverImageUrl;

  @override
  Widget build(BuildContext context) {
    audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: FutureBuilder<List<Audiobook>>(
        future: favoritesService.getBookmarks(widget.user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error loading bookmarks: ${snapshot.error}');
          } else {
            bookmarks = snapshot.data ?? [];
            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final audiobook = bookmarks[index];
                return ListTile(
                  leading: audiobookCoverImageUrl != null
                      ? Image.network(audiobookCoverImageUrl!)
                      : null,
                  title: Text(audiobook.title),
                  subtitle: Text(audiobook.author),
                  onTap: () {
                    _showPlayerSheet(audiobook);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeBookmark(audiobook);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _loadAudiobookCoverImage(int index) async {
    try {
      DocumentSnapshot audiobookSnapshot = await FirebaseFirestore.instance
          .collection('audiobooks')
          .doc(bookmarks[index].id)
          .get();

      String? imageUrl = audiobookSnapshot['coverImageUrl'];

      if (imageUrl != null && Uri.parse(imageUrl).isAbsolute) {
        setState(() {
          audiobookCoverImageUrl = imageUrl;
        });
      } else {
        print('Invalid or missing cover image URL: $imageUrl');
      }
    } catch (e) {
      print('Error loading audiobook cover image: $e');
    }
  }

  void _showPlayerSheet(Audiobook audiobook) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              Text(
                'Now Playing: ${audiobook.title}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Slider(
                value: audioPlayerProvider.position.inSeconds.toDouble(),
                onChanged: (value) {
                  audioPlayerProvider.seek(Duration(seconds: value.toInt()));
                },
                max: audioPlayerProvider.duration.inSeconds.toDouble(),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      audioPlayerProvider.play(audiobook.audioFileUrl!);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () {
                      audioPlayerProvider.pause();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removeBookmark(Audiobook audiobook) async {
    try {
      await favoritesService.removeBookmark(widget.user.uid, audiobook);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bookmark removed'),
          ),
        );
      });
    } catch (e) {
      print('Error removing bookmark: $e');
    }
  }
}
