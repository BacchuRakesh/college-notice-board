import 'package:flutter/foundation.dart';

import '../models/departments.dart';
import '../models/notice.dart';
import 'notice_storage_service.dart';

enum LoadStatus { loading, ready, error }

/// Holds every notice and the selected filter. The list, detail, form and
/// pinned screens all read from this one store.
class NoticeProvider extends ChangeNotifier {
  NoticeProvider(this._storage);

  final NoticeStorageService _storage;

  List<Notice> _notices = [];
  LoadStatus _status = LoadStatus.loading;
  String? _errorMessage;
  String _selectedDepartment = allDepartments;

  LoadStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get selectedDepartment => _selectedDepartment;
  bool get hasNotices => _notices.isNotEmpty;

  /// Notices for the selected department, pinned first, then newest first.
  List<Notice> get visibleNotices {
    final list = _selectedDepartment == allDepartments
        ? List<Notice>.of(_notices)
        : _notices.where((n) => n.department == _selectedDepartment).toList();
    list.sort(_compare);
    return list;
  }

  List<Notice> get pinnedNotices {
    final list = _notices.where((n) => n.pinned).toList();
    list.sort(_compare);
    return list;
  }

  Notice? findById(String id) {
    for (final notice in _notices) {
      if (notice.id == id) {
        return notice;
      }
    }
    return null;
  }

  Future<void> load() async {
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _notices = await _storage.load();
      _status = LoadStatus.ready;
    } catch (_) {
      _status = LoadStatus.error;
      _errorMessage = 'Could not read the saved notices.';
    }
    notifyListeners();
  }

  void selectDepartment(String department) {
    if (department == _selectedDepartment) {
      return;
    }
    _selectedDepartment = department;
    notifyListeners();
  }

  Future<bool> addNotice({
    required String title,
    required String description,
    required String department,
    required DateTime date,
    required String postedBy,
  }) {
    final notice = Notice(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      department: department,
      date: date,
      postedBy: postedBy,
    );
    return _persist([..._notices, notice]);
  }

  Future<bool> deleteNotice(String id) {
    return _persist(_notices.where((n) => n.id != id).toList());
  }

  Future<bool> togglePin(String id) {
    return _persist(
      _notices
          .map((n) => n.id == id ? n.copyWith(pinned: !n.pinned) : n)
          .toList(),
    );
  }

  /// Saves first and only then updates the in-memory list, so what the user
  /// sees always matches what is stored.
  Future<bool> _persist(List<Notice> updated) async {
    try {
      await _storage.save(updated);
      _notices = updated;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  int _compare(Notice a, Notice b) {
    if (a.pinned != b.pinned) {
      return a.pinned ? -1 : 1;
    }
    return b.date.compareTo(a.date);
  }
}
