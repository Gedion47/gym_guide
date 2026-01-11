import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  static String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear all workout and diet selections for new users
    await prefs.remove('full_body_selected');
    await prefs.remove('chest_selected');
    await prefs.remove('abs_selected');
    await prefs.remove('aerobics_selected');

    // Clear progress data
    await prefs.remove('full_body_progress_completed');
    await prefs.remove('full_body_progress_target');
    await prefs.remove('chest_progress_completed');
    await prefs.remove('chest_progress_target');

    // Clear premium status
    await prefs.remove('is_premium_unlocked');

    // Clear completed dates
    await prefs.remove('completed_dates');

    // Set user as initialized
    await prefs.setBool('user_initialized_${getCurrentUserId()}', true);
  }

  static Future<bool> isUserInitialized() async {
    final userId = getCurrentUserId();
    if (userId == null) return false;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('user_initialized_$userId') ?? false;
  }
}
