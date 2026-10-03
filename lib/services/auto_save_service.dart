import 'dart:async';
import 'package:flutter/foundation.dart';
import 'local_storage_service.dart';

/// Auto-save service (F6).
/// Saves open files and notes automatically every 5 minutes.
/// Writes to local storage first, then cloud sync (when implemented) in the background.
class AutoSaveService {
  static final AutoSaveService _instance = AutoSaveService._internal();
  factory AutoSaveService() => _instance;
  AutoSaveService._internal();

  Timer? _timer;
  bool _isRunning = false;
  DateTime? _lastSaveTime;

  bool get isRunning => _isRunning;
  DateTime? get lastSaveTime => _lastSaveTime;

  /// Start auto-saving at the given interval.
  void start({Duration interval = const Duration(minutes: 5)}) {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(interval, (_) => _performSave());
    debugPrint('[Edith AutoSave] Started with interval: ${interval.inMinutes}min');
  }

  /// Stop the auto-save timer.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    debugPrint('[Edith AutoSave] Stopped');
  }

  /// Perform an immediate save (can be called manually too).
  Future<void> saveNow() async {
    await _performSave();
  }

  Future<void> _performSave() async {
    try {
      await LocalStorageService().saveData();
      _lastSaveTime = DateTime.now();
      debugPrint('[Edith AutoSave] Saved at $_lastSaveTime');
    } catch (e) {
      debugPrint('[Edith AutoSave] Error: $e');
    }
  }

  /// Clean up resources.
  void dispose() {
    stop();
  }
}
