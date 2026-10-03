import 'package:shared_preferences/shared_preferences.dart';

/// Web storage implementation.
/// Uses SharedPreferences as a simple key-value store for JSON metadata.
/// Web is not a PRD target but this prevents crashes.

Future<Map<String, String?>> loadAllData() async {
  final prefs = await SharedPreferences.getInstance();
  final result = <String, String?>{};
  for (final key in ['files', 'folders', 'notes']) {
    result[key] = prefs.getString('edith_$key');
  }
  return result;
}

Future<void> saveAllData(Map<String, String> data) async {
  final prefs = await SharedPreferences.getInstance();
  for (final entry in data.entries) {
    await prefs.setString('edith_${entry.key}', entry.value);
  }
}
