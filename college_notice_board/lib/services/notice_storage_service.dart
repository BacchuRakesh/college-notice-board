import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/notice.dart';

/// Reads and writes the list of notices on the phone so it survives a restart.
/// Errors (for example corrupted saved data) are thrown to the caller.
class NoticeStorageService {
  static const String _storageKey = 'college_notices';

  Future<List<Notice>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Notice.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<Notice> notices) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(notices.map((n) => n.toJson()).toList());
    final saved = await prefs.setString(_storageKey, encoded);
    if (!saved) {
      throw StateError('Could not write notices to storage');
    }
  }
}
