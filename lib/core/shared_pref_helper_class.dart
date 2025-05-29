// lib/core/utils/shared_pref_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String _phoneKey = 'user_phone';

  static Future<void> savePhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, phone);
  }

  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }

  static Future<void> clearPhone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_phoneKey);
  }
}
