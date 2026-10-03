import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../models/edith_file.dart';
import '../models/note.dart';
import 'local_storage_service.dart';

class ImageInputService {
  final ImagePicker _picker = ImagePicker();
  final LocalStorageService _storage = LocalStorageService();
  final Uuid _uuid = const Uuid();

  Future<EdithFile?> captureAndImportImage({String? parentFolderId}) async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return null;

      final originalFile = File(photo.path);
      final fileName = photo.name;
      
      final appDir = await getApplicationDocumentsDirectory();
      final newPath = '${appDir.path}/$fileName';
      
      final copiedFile = await originalFile.copy(newPath);
      final size = await copiedFile.length();

      final edithFile = EdithFile(
        id: _uuid.v4(),
        displayName: fileName,
        path: copiedFile.path,
        type: 'image',
        parentFolderId: parentFolderId,
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: size,
      );

      _storage.addFile(edithFile);

      // Perform OCR
      _performOcrAndCreateNote(edithFile);

      return edithFile;
    } catch (e) {
      debugPrint("Error capturing image: $e");
      return null;
    }
  }

  Future<void> _performOcrAndCreateNote(EdithFile file) async {
    try {
      final inputImage = InputImage.fromFilePath(file.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      if (recognizedText.text.trim().isNotEmpty) {
        final note = Note(
          id: _uuid.v4(),
          fileId: file.id,
          text: recognizedText.text,
          labels: ['ocr', 'auto-generated'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _storage.addNote(note);
      }
      
      textRecognizer.close();
    } catch (e) {
      debugPrint("Error during OCR: $e");
    }
  }
}
