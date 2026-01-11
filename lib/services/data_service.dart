import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_guide/services/firebase_service.dart';

class DataService {
  // workout selection keys
  static const String fullBodyKey = 'full_body_selected';
  static const String chestKey = 'chest_selected';

  // diet selection keys
  static const String absDietKey = 'abs_selected';
  static const String aerobicsDietKey = 'aerobics_selected';

  // workout progress keys
  static const String fullBodyProgressKey = 'full_body_progress';
  static const String chestProgressKey = 'chest_progress';

  // calendar and midnight keys
  static const String completedDatesKey = 'completed_dates';
  static const String lastActiveDateKey = 'last_active_date';

  // Helper method to get user-specific key
  static String _getUserKey(String baseKey) {
    final userId = FirebaseService.getCurrentUserId();
    return userId != null ? '${userId}_$baseKey' : baseKey;
  }

  // workout selection
  static Future<void> saveWorkoutSelection(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_getUserKey(key), value);
  }

  static Future<bool> loadWorkoutSelection(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_getUserKey(key)) ?? false;
  }

  // diet selection
  static Future<void> saveDietSelection(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_getUserKey(key), value);
  }

  static Future<bool> loadDietSelection(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_getUserKey(key)) ?? false;
  }

  // workout progress
  static Future<void> saveWorkoutProgress(String key, Map<String, int> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_getUserKey('${key}_completed'), progress['completed'] ?? 0);
    await prefs.setInt(_getUserKey('${key}_target'), progress['target'] ?? 0);
  }

  static Future<Map<String, int>> loadWorkoutProgress(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'completed': prefs.getInt(_getUserKey('${key}_completed')) ?? 0,
      'target': prefs.getInt(_getUserKey('${key}_target')) ?? (key == fullBodyProgressKey ? 3 : 4),
    };
  }

  // calendar
  static Future<void> saveCompletedDates(List<DateTime> dates) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _getUserKey(completedDatesKey),
      dates.map((d) => d.toIso8601String()).toList(),
    );
  }

  static Future<List<DateTime>> loadCompletedDates() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_getUserKey(completedDatesKey)) ?? [];
    return list.map(DateTime.parse).toList();
  }

  // midnight reset
  static Future<void> saveLastActiveDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_getUserKey(lastActiveDateKey), date.toIso8601String());
  }

  static Future<DateTime?> loadLastActiveDate() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_getUserKey(lastActiveDateKey));
    return str == null ? null : DateTime.parse(str);
  }
}
