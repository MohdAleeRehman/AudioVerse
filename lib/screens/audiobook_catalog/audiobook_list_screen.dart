import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audio_verse/models/audiobook.dart';
import 'package:audio_verse/screens/audiobook_catalog/audiobook_details_screen.dart';

// ignore: must_be_immutable
class AudiobookListScreen extends StatelessWidget {
  late final List<Audiobook> audiobooks;
  String? audiobookCoverImageUrl;

  AudiobookListScreen(
      {required this.audiobooks}); // Initialize the audiobooks list in the constructor

  Future<void> _loadAudiobookCoverImage(int index) async {
    try {
      // Fetch the audiobook document from Firestore
      DocumentSnapshot audiobookSnapshot = await FirebaseFirestore.instance
          .collection('audiobooks')
          .doc(audiobooks[index].id)
          .get();

      // Get the cover image URL from the document
      audiobookCoverImageUrl = audiobookSnapshot['coverImageUrl'];
    } catch (e) {
      print('Error loading audiobook cover image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audiobook Catalog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: audiobooks.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: FutureBuilder<void>(
                  future: _loadAudiobookCoverImage(index),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        audiobookCoverImageUrl != null) {
                      return Image.network(audiobookCoverImageUrl!);
                    } else {
                      return CircularProgressIndicator(); // You can replace this with a placeholder image
                    }
                  },
                ),
                title: Text(audiobooks[index].title),
                subtitle: Text(audiobooks[index].author),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudiobookDetailsScreen(
                        audiobook: audiobooks[index],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
