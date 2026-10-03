import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/edith_file.dart';

class CloudStorageService {
  final FirebaseFirestore _firestore;
  final http.Client _httpClient;

  CloudStorageService({
    FirebaseFirestore? firestore,
    http.Client? httpClient,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _httpClient = httpClient ?? http.Client();

  /// Upload bytes to Backblaze B2, then metadata to Firestore on success.
  Future<bool> uploadFile(EdithFile file, {File? diskFile, String? uploadUrl, String? token}) async {
    try {
      // 1. Upload file bytes to B2 if on native and file provided
      if (!kIsWeb && diskFile != null && await diskFile.exists()) {
        if (uploadUrl == null || token == null) {
          debugPrint('Upload URL or token missing for B2.');
          return false;
        }
        
        final bytes = await diskFile.readAsBytes();
        
        final response = await _httpClient.post(
          Uri.parse(uploadUrl),
          headers: {
            'Authorization': token,
            'X-Bz-File-Name': file.id,
            'Content-Type': 'application/octet-stream',
          },
          body: bytes,
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode != 200) {
          debugPrint('B2 upload failed: ${response.statusCode} - ${response.body}');
          return false;
        }
      }

      // 2. Upload metadata to Firestore only if bytes upload succeeds (or no bytes provided)
      await _firestore.collection('files').doc(file.id).set(file.toJson());

      return true;
    } catch (e) {
      debugPrint("Error uploading file: $e");
      return false;
    }
  }

  /// Download file bytes from Backblaze B2.
  Future<bool> downloadFile(EdithFile file, String downloadPath, {String? downloadUrl, String? token}) async {
    try {
      if (kIsWeb) return false;
      
      if (downloadUrl == null || token == null) {
        debugPrint('Download URL or token missing for B2.');
        return false;
      }

      final response = await _httpClient.get(
        Uri.parse(downloadUrl),
        headers: {
          'Authorization': token,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final diskFile = File(downloadPath);
        await diskFile.writeAsBytes(response.bodyBytes);
        return true;
      } else {
        debugPrint('B2 download failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint("Error downloading file: $e");
      return false;
    }
  }

  /// Sync metadata from Firestore
  Future<List<EdithFile>> syncMetadata() async {
    try {
      final snapshot = await _firestore.collection('files').get();
      return snapshot.docs.map((doc) => EdithFile.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint("Error syncing metadata: $e");
      return [];
    }
  }
}
