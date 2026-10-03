import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Native (Android, iOS, Windows, macOS, Linux) storage implementation.
/// Uses path_provider + dart:io File to read/write JSON files.

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  final edithDir = Directory('${directory.path}/edith_data');
  if (!await edithDir.exists()) {
    await edithDir.create(recursive: true);
  }
  return edithDir.path;
}

Future<Map<String, String?>> loadAllData() async {
  final path = await _localPath;
  final result = <String, String?>{};

  for (final key in ['files', 'folders', 'notes']) {
    final file = File('$path/edith_$key.json');
    if (await file.exists()) {
      result[key] = await file.readAsString();
    }
  }
  return result;
}

Future<void> saveAllData(Map<String, String> data) async {
  final path = await _localPath;

  for (final entry in data.entries) {
    final file = File('$path/edith_${entry.key}.json');
    await file.writeAsString(entry.value);
  }
}
