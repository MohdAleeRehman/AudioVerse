// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZOhxPqLYCvbpnuRT352u4h72IHb4fxkU',
    appId: '1:1082178851347:android:bc29a7093eb9e09bede5e6',
    messagingSenderId: '1082178851347',
    projectId: 'my-awesome-4daee',
    storageBucket: 'my-awesome-4daee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCA-LSQQecAObGW_GhoafJ3LKKiczfFrxs',
    appId: '1:1082178851347:ios:d52d1634f43e8377ede5e6',
    messagingSenderId: '1082178851347',
    projectId: 'my-awesome-4daee',
    storageBucket: 'my-awesome-4daee.appspot.com',
    iosBundleId: 'com.example.audioVerse',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCA-LSQQecAObGW_GhoafJ3LKKiczfFrxs',
    appId: '1:1082178851347:ios:8c219805c2afe199ede5e6',
    messagingSenderId: '1082178851347',
    projectId: 'my-awesome-4daee',
    storageBucket: 'my-awesome-4daee.appspot.com',
    iosBundleId: 'com.example.audioVerse.RunnerTests',
  );
}
