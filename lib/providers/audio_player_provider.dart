import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _userId;

  String? get userId => _userId;

  bool get isPlaying => _audioPlayer.playing;
  Duration get duration => _audioPlayer.duration ?? Duration.zero;
  Duration get position => _audioPlayer.position;

  double get playbackSpeed => _audioPlayer.speed;

  AudioPlayerProvider() {
    _audioPlayer.positionStream.listen((event) {
      notifyListeners();
    });
    _audioPlayer.durationStream.listen((event) {
      notifyListeners();
    });
    _audioPlayer.playbackEventStream.listen((event) {
      notifyListeners();
    });
  }

  Future<void> setUserId(String userId) async {
    _userId = userId;
    notifyListeners();
  }

  Future<void> play(String url) async {
    try {
      if (_userId != null) {
        print('User ID: $_userId');
      }

      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  Future<void> changeSpeed(double speed) async {
    try {
      await _audioPlayer.setSpeed(speed);
    } catch (e) {
      print('Error setting playback speed: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void initListeners() {
    _audioPlayer.positionStream.listen((event) {
      notifyListeners();
    });
    _audioPlayer.durationStream.listen((event) {
      notifyListeners();
    });
    _audioPlayer.playbackEventStream.listen((event) {
      notifyListeners();
    });
  }
}
