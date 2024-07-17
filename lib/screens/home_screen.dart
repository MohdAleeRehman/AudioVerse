import 'package:audio_verse/models/audiobook.dart';
import 'package:audio_verse/screens/audiobook_catalog/add_audiobook_screen.dart';
import 'package:audio_verse/screens/audiobook_catalog/audiobook_list_screen.dart';
import 'package:audio_verse/screens/bookmarks/bookmarks_screen.dart';
import 'package:audio_verse/services/audiobook_service.dart';
import 'package:flutter/material.dart';
import 'package:audio_verse/models/user.dart';
import 'package:audio_verse/services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  final MyAppUser user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userProfileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfileImage();
  }

  Future<void> _loadUserProfileImage() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .get();

      setState(() {
        userProfileImageUrl = userSnapshot['profilePictureUrl'];
      });
    } catch (e) {
      print('Error loading user profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.user.username}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await AuthenticationService().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display user image
            if (userProfileImageUrl != null)
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(userProfileImageUrl!),
              ),
            SizedBox(height: 8),
            Text(
              'Username: ${widget.user.username}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAudiobookScreen(),
                  ),
                );
              },
              child: Text('Add Audiobook'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                List<Audiobook> audiobooks =
                    await AudiobookService().getAudiobooks();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudiobookListScreen(
                      audiobooks: audiobooks,
                    ),
                  ),
                );
              },
              child: Text('Audiobooks'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookmarksScreen(
                      user: widget.user,
                    ),
                  ),
                );
              },
              child: Text('Bookmarks'),
            ),
          ],
        ),
      ),
    );
  }
}
