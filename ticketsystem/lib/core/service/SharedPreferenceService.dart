import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _accessTokenKey = 'access_token';

  // Save access token
  static Future<void> saveToken(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
  }

  // Retrieve access token
  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }



  // Clear access token
  static Future<void> clearAllTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }
}