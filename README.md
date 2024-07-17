# AudioVerse

AudioVerse is a Flutter application for listening to audiobooks. It features user authentication, bookmarking, and audio playback functionalities integrated with Firebase.

## Features

- User Authentication (Login, Signup, Password Recovery)
- Audiobook Catalog
- Audio Playback with pause and play controls
- Bookmark management
- User profile with profile picture

## Screens

1. **Login Screen**: Allows users to log in with their credentials.
2. **Signup Screen**: New users can create an account.
3. **Password Recovery Screen**: Users can recover their password.
4. **Home Screen**: Displays user information and navigation options.
5. **Audiobook List Screen**: Displays a list of available audiobooks.
6. **Add Audiobook Screen**: Allows users to add new audiobooks to the catalog.
7. **Bookmarks Screen**: Displays the user's bookmarked audiobooks.

## Dependencies

- flutter
- provider
- firebase_core
- firebase_auth
- cloud_firestore
- just_audio

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/audioverse.git
   cd audioverse

2. Install dependencies:
   ```sh
   flutter pub get

3. Set up Firebase:

1. Go to the Firebase Console and create a new project.
2. Add an Android/iOS app to your Firebase project.
3. Download the google-services.json (for Android) and GoogleService-Info.plist (for iOS) files and place them in the respective directories in your Flutter project.
4. Enable Firebase Authentication and Firestore in your Firebase project.

5. Run the app:
   ```sh
   flutter run

