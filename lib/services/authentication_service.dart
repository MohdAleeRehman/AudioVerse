import 'package:audio_verse/models/user.dart';
import 'package:audio_verse/providers/audio_player_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final audioPlayeProvider = AudioPlayerProvider();

  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
    File? profilePicture,
  }) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = authResult.user;

      if (user != null) {
        // Store user information in Firestore
        await _usersCollection.doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'username': username,
          'profilePictureUrl': null, // Placeholder value
        });

        // Upload profile picture to Firebase Storage
        if (profilePicture != null) {
          Reference storageReference =
              _storage.ref().child('profile_pictures/${user.uid}');
          UploadTask uploadTask = storageReference.putFile(profilePicture);

          await uploadTask.whenComplete(() async {
            String profilePictureUrl = await storageReference.getDownloadURL();
            await _usersCollection
                .doc(user.uid)
                .update({'profilePictureUrl': profilePictureUrl});
          });
        }

        return null;
      } else {
        return 'Sign-up failed. Please try again.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<MyAppUser?> getCurrentUser() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot =
          await _usersCollection.doc(user.uid).get();

      String? userId = userSnapshot['uid'];
      audioPlayeProvider.setUserId(userId!);

      return MyAppUser(
        uid: userSnapshot['uid'],
        email: userSnapshot['email'],
        username: userSnapshot['username'],
        profilePictureUrl: userSnapshot['profilePictureUrl'],
      );
    } else {
      return null;
    }
  }

  Future resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
