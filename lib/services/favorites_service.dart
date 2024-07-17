import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audio_verse/models/audiobook.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const _bookmarksCollection = 'bookmarks';

  Future<List<Audiobook>> getBookmarks(String userId) async {
    try {
      final bookmarkSnapshot = await _firestore
          .collection(_bookmarksCollection)
          .doc(userId)
          .collection('user_bookmarks')
          .get();

      List<Audiobook> bookmarks = bookmarkSnapshot.docs
          .map((doc) => Audiobook.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return bookmarks;
    } catch (e) {
      print('Error getting bookmarks: $e');
      return [];
    }
  }

  Future<void> addBookmark(String userId, Audiobook audiobook) async {
    try {
      await _firestore
          .collection(_bookmarksCollection)
          .doc(userId)
          .collection('user_bookmarks')
          .doc(audiobook.id)
          .set(audiobook.toJson());
    } catch (e) {
      print('Error adding bookmark: $e');
    }
  }

  Future<void> removeBookmark(String userId, Audiobook audiobook) async {
    try {
      await _firestore
          .collection(_bookmarksCollection)
          .doc(userId)
          .collection('user_bookmarks')
          .doc(audiobook.id)
          .delete();
    } catch (e) {
      print('Error removing bookmark: $e');
    }
  }
}
