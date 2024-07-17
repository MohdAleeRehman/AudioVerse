import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audio_verse/models/audiobook.dart';

class AudiobookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static const _audiobooksCollection = 'audiobooks';
  static const _audiobookStorageFolder = 'audiobooks';

  Future<List<Audiobook>> getAudiobooks() async {
    try {
      final audiobookSnapshot =
          await _firestore.collection(_audiobooksCollection).get();

      List<Audiobook> audiobooks = audiobookSnapshot.docs
          .map((doc) => Audiobook.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return audiobooks;
    } catch (e) {
      print('Error getting audiobooks: $e');
      return [];
    }
  }

  Future<String?> addAudiobooks({
    required String id,
    required String title,
    required String author,
    File? coverImage,
    File? audioFile,
  }) async {
    try {
      await _firestore.collection(_audiobooksCollection).doc(id).set({
        'id': id,
        'title': title,
        'author': author,
        'coverImageUrl': null,
        'audioFileUrl': null,
      });

      if (coverImage != null) {
        Reference storageReference =
            _storage.ref().child('$_audiobookStorageFolder/$id/coverImage');
        UploadTask uploadTask = storageReference.putFile(coverImage);

        await uploadTask.whenComplete(() async {
          String coverImageUrl = await storageReference.getDownloadURL();
          await _firestore
              .collection(_audiobooksCollection)
              .doc(id)
              .update({'coverImageUrl': coverImageUrl});
        });
      }

      if (audioFile != null) {
        Reference storageReference =
            _storage.ref().child('$_audiobookStorageFolder/$id/audioFile');
        UploadTask uploadTask = storageReference.putFile(audioFile);

        await uploadTask.whenComplete(() async {
          String audioFileUrl = await storageReference.getDownloadURL();
          await _firestore
              .collection(_audiobooksCollection)
              .doc(id)
              .update({'audioFileUrl': audioFileUrl});
        });
      }
      return null;
    } catch (e) {
      print('Error adding audiobook: $e');
    }
    return null;
  }
}
