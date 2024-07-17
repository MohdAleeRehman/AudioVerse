import 'dart:io';
import 'package:audio_verse/services/audiobook_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddAudiobookScreen extends StatefulWidget {
  const AddAudiobookScreen({super.key});

  @override
  State<AddAudiobookScreen> createState() => _AddAudiobookScreenState();
}

class _AddAudiobookScreenState extends State<AddAudiobookScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  File? _pickedCoverImage;
  File? _pickedAudioFile;
  final AudiobookService _audiobookService = AudiobookService();

  void _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _pickedCoverImage = File(pickedImage.path);
      }
    });
  }

  void _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );

      if (result != null) {
        setState(() {
          _pickedAudioFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print('Error picking audio file: $e');
    }
  }

  void _addAudiobooks() async {
    String id = _idController.text.trim();
    String title = _titleController.text.trim();
    String author = _authorController.text.trim();

    String? errorMessage = await _audiobookService.addAudiobooks(
      id: id,
      title: title,
      author: author,
      coverImage: _pickedCoverImage,
      audioFile: _pickedAudioFile,
    );

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Audiobook'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'ID'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickCoverImage,
              child: const Text('Pick Cover Image'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickAudioFile,
              child: const Text('Pick Audio File'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addAudiobooks,
              child: const Text('Add Audiobook'),
            ),
          ],
        ),
      ),
    );
  }
}
