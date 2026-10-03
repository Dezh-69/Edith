import 'dart:io';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/edith_file.dart';
import 'local_storage_service.dart';

class FileService {
  final LocalStorageService _storage = LocalStorageService();
  final Uuid _uuid = const Uuid();

  /// Pick a file from the device and import it into Edith's library.
  /// Supports: pdf, jpg, jpeg, png, docx, doc
  Future<EdithFile?> pickAndImportFile({String? parentFolderId}) async {
    try {
      final result = await fp.FilePicker.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'docx', 'doc'],
      );

      if (result.isEmpty) return null;
      
      final pickedFile = result.first;
      final fileName = pickedFile.name;
      final extension = pickedFile.extension?.toLowerCase() ?? '';

      // Determine file type
      String type = 'image';
      if (extension == 'pdf') {
        type = 'pdf';
      } else if (extension == 'docx' || extension == 'doc') {
        type = 'word';
      }

      String savedPath;
      int fileSize;

      if (kIsWeb) {
        // Web: can't copy files, just store reference
        savedPath = 'web://$fileName';
        fileSize = 0; // Size not available on web without bytes
      } else {
        // Native: copy to app documents directory
        if (pickedFile.path == null) return null;
        
        final originalFile = File(pickedFile.path!);
        final appDir = await getApplicationDocumentsDirectory();
        final edithDir = Directory('${appDir.path}/edith_files');
        if (!await edithDir.exists()) {
          await edithDir.create(recursive: true);
        }
        
        // Generate unique filename to avoid collisions
        final uniqueName = '${_uuid.v4().substring(0, 8)}_$fileName';
        final newPath = '${edithDir.path}/$uniqueName';
        
        final copiedFile = await originalFile.copy(newPath);
        savedPath = copiedFile.path;
        fileSize = await copiedFile.length();
      }

      final edithFile = EdithFile(
        id: _uuid.v4(),
        displayName: fileName,
        path: savedPath,
        type: type,
        parentFolderId: parentFolderId,
        createdAt: DateTime.now(),
        lastOpenedAt: DateTime.now(),
        sizeBytes: fileSize,
      );

      _storage.addFile(edithFile);
      return edithFile;
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
    return null;
  }

  /// Delete a file from both the library index and disk.
  Future<void> deleteFile(EdithFile file) async {
    try {
      if (!kIsWeb && file.path != 'dummy' && !file.path.startsWith('web://')) {
        final diskFile = File(file.path);
        if (await diskFile.exists()) {
          await diskFile.delete();
        }
      }
      _storage.removeFile(file.id);
    } catch (e) {
      debugPrint("Error deleting file: $e");
    }
  }

  /// Get a human-readable size string.
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format a relative time string (e.g. "12m ago", "2h ago", "Yesterday").
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
