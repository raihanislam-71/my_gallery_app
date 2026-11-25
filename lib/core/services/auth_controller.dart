import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static String? accessToken;
  static String? userEmail;

  final String _accessTokenKey = 'access-token';
  final String _userEmailKey = 'user-email';

  Future<void> saveAccessToken(String token, {String? email}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
    if (email != null && email.isNotEmpty) {
      await sharedPreferences.setString(_userEmailKey, email);
      userEmail = email;
    }
  }

  Future<String?> getAccessToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? token = sharedPreferences.getString(_accessTokenKey);
    userEmail = sharedPreferences.getString(_userEmailKey);
    accessToken = token;
    return token;
  }

  Future<void> clearUserData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    accessToken = null;
    userEmail = null;
  }

  Future<void> clearAccessToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessTokenKey);
    accessToken = null;
  }

  bool isLoggedInUser() {
    return accessToken != null && accessToken!.isNotEmpty;
  }
}
