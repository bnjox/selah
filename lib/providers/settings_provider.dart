import 'package:flutter/foundation.dart';
import '../services/database_service.dart';

class SettingsProvider with ChangeNotifier {
  bool _notificationsEnabled = false;
  bool _streakEnabled = false;
  final DatabaseService _db = DatabaseService();

  bool get notificationsEnabled => _notificationsEnabled;
  bool get streakEnabled => _streakEnabled;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final settings = await _db.getSettings();
    for (var setting in settings) {
      if (setting.key == 'notificationsEnabled') {
        _notificationsEnabled = setting.value == 'true';
      } else if (setting.key == 'streakEnabled') {
        _streakEnabled = setting.value == 'true';
      }
    }
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    await _db.updateSetting('notificationsEnabled', value.toString());
    notifyListeners();
  }

  Future<void> toggleStreak(bool value) async {
    _streakEnabled = value;
    await _db.updateSetting('streakEnabled', value.toString());
    notifyListeners();
  }
}
