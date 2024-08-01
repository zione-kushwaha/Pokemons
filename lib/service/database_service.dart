import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  DatabaseService();

  Future<bool?> saveList(String key, List<String> value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setStringList(key, value);
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<String>?> getList(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(key);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
