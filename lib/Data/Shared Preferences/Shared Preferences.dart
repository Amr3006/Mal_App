// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferencees;

  static inti() async {
    _sharedPreferencees = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData(
    String key,
    dynamic value
  ) async {
    if (value is bool) {
      return await _sharedPreferencees.setBool(key, value);
    } else if (value is double) {
      return await _sharedPreferencees.setDouble(key, value);
    } else if (value is String) {
      return await _sharedPreferencees.setString(key, value);
    } else if (value is int) {
      return await _sharedPreferencees.setInt(key, value);
    }
    return false;
  }

  static dynamic getData(String key) {
    return _sharedPreferencees.get(key);
  }
}