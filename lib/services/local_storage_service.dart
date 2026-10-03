import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/edith_file.dart';
import '../models/note.dart';
import '../models/folder.dart';

// Conditional imports for platform-specific file I/O
import 'storage_native.dart' if (dart.library.html) 'storage_web.dart' as platform_storage;

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  List<EdithFile> _files = [];
  List<Folder> _folders = [];
  List<Note> _notes = [];

  bool _initialized = false;
  Timer? _autoSaveTimer;

  List<EdithFile> get files => List.unmodifiable(_files);
  List<Folder> get folders => List.unmodifiable(_folders);
  List<Note> get notes => List.unmodifiable(_notes);
  bool get isInitialized => _initialized;

  /// Initialize the storage service and load persisted data.
  Future<void> init() async {
    if (_initialized) return;
    await loadData();
    _initialized = true;
  }

  /// Start auto-save timer (F6: every 5 minutes).
  void startAutoSave({Duration interval = const Duration(minutes: 5)}) {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(interval, (_) {
      saveData();
      debugPrint('[Edith] Auto-saved at ${DateTime.now()}');
    });
  }

  /// Stop auto-save timer.
  void stopAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
  }

  // ---------------------------------------------------------------------------
  // Persistence
  // ---------------------------------------------------------------------------

  Future<void> loadData() async {
    try {
      final data = await platform_storage.loadAllData();
      if (data['files'] != null) {
        final List<dynamic> jsonList = jsonDecode(data['files']!);
        _files = jsonList.map((e) => EdithFile.fromJson(e)).toList();
      }
      if (data['folders'] != null) {
        final List<dynamic> jsonList = jsonDecode(data['folders']!);
        _folders = jsonList.map((e) => Folder.fromJson(e)).toList();
      }
      if (data['notes'] != null) {
        final List<dynamic> jsonList = jsonDecode(data['notes']!);
        _notes = jsonList.map((e) => Note.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
  }

  Future<void> saveData() async {
    try {
      await platform_storage.saveAllData({
        'files': jsonEncode(_files.map((e) => e.toJson()).toList()),
        'folders': jsonEncode(_folders.map((e) => e.toJson()).toList()),
        'notes': jsonEncode(_notes.map((e) => e.toJson()).toList()),
      });
    } catch (e) {
      debugPrint("Error saving data: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // Files CRUD
  // ---------------------------------------------------------------------------

  void addFile(EdithFile file) {
    _files.add(file);
    saveData();
  }

  void updateFile(EdithFile file) {
    final index = _files.indexWhere((e) => e.id == file.id);
    if (index != -1) {
      _files[index] = file;
      saveData();
    }
  }

  void removeFile(String id) {
    _files.removeWhere((e) => e.id == id);
    _notes.removeWhere((n) => n.fileId == id);
    saveData();
  }

  /// Rename a file (F15).
  void renameFile(String id, String newName) {
    final index = _files.indexWhere((e) => e.id == id);
    if (index != -1) {
      _files[index].displayName = newName;
      saveData();
    }
  }

  /// Move a file to a different folder (F15).
  void moveFileToFolder(String id, String? folderId) {
    final index = _files.indexWhere((e) => e.id == id);
    if (index != -1) {
      _files[index].parentFolderId = folderId;
      saveData();
    }
  }

  // ---------------------------------------------------------------------------
  // Folders CRUD (F15)
  // ---------------------------------------------------------------------------

  void addFolder(Folder folder) {
    _folders.add(folder);
    saveData();
  }

  void renameFolder(String id, String newName) {
    final index = _folders.indexWhere((e) => e.id == id);
    if (index != -1) {
      _folders[index].name = newName;
      saveData();
    }
  }

  void removeFolder(String id) {
    // Move orphaned files back to root
    for (final file in _files) {
      if (file.parentFolderId == id) {
        file.parentFolderId = null;
      }
    }
    _folders.removeWhere((e) => e.id == id);
    saveData();
  }

  // ---------------------------------------------------------------------------
  // Notes CRUD
  // ---------------------------------------------------------------------------

  void addNote(Note note) {
    _notes.add(note);
    saveData();
  }

  void updateNote(Note note) {
    final index = _notes.indexWhere((e) => e.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      saveData();
    }
  }

  void removeNote(String id) {
    _notes.removeWhere((e) => e.id == id);
    saveData();
  }

  List<Note> getNotesForFile(String fileId) {
    return _notes.where((n) => n.fileId == fileId).toList();
  }

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  /// Get files in a specific folder (or root if folderId is null).
  List<EdithFile> getFilesInFolder(String? folderId) {
    return _files.where((f) => f.parentFolderId == folderId).toList();
  }

  /// Get subfolders of a folder.
  List<Folder> getSubfolders(String? parentId) {
    return _folders.where((f) => f.parentFolderId == parentId).toList();
  }

  /// Search files by display name.
  List<EdithFile> searchFiles(String query) {
    if (query.isEmpty) return _files;
    final lower = query.toLowerCase();
    return _files.where((f) => f.displayName.toLowerCase().contains(lower)).toList();
  }

  /// Filter files by various criteria (type, size, date).
  List<EdithFile> filterFiles({
    String? type,
    int? minSizeBytes,
    int? maxSizeBytes,
    DateTime? afterDate,
    DateTime? beforeDate,
  }) {
    return _files.where((f) {
      if (type != null && f.type != type) return false;
      if (minSizeBytes != null && f.sizeBytes < minSizeBytes) return false;
      if (maxSizeBytes != null && f.sizeBytes > maxSizeBytes) return false;
      if (afterDate != null && f.createdAt.isBefore(afterDate)) return false;
      if (beforeDate != null && f.createdAt.isAfter(beforeDate)) return false;
      return true;
    }).toList();
  }
}
