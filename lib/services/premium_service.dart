import 'package:shared_preferences/shared_preferences.dart';

class PremiumService {
  static const String _premiumKey = 'is_premium_unlocked';

  // Check if premium is unlocked
  static Future<bool> isPremiumUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_premiumKey) ?? false;
  }

  // Unlock premium features
  static Future<void> unlockPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, true);
  }

  // Lock premium features (for testing)
  static Future<void> lockPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, false);
  }
}
