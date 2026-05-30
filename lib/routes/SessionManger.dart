import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {

  static const String _tokenKey = "token";
  static const String _userIdKey = "user_id";
  static const String _userNameKey = "user_name";
  static const String _userEmailKey = "user_email";
  static const String _adminLoggedIn = "adminLoggedIn";
  static const String _userRoleKey = "user_role";
  static const String _roleSelectedKey = "roleSelected";
  static const String _giftOpenedKey = "gift_opened";

  /// Save Login Data
  static Future<void> saveUserSession({
    required String token,
    required int userId,
    required String name,
    required String email,
  }) async
  {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
  }

  static Future<void> setRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
    await prefs.setBool(_roleSelectedKey, true);
  }
  static Future<bool> isRoleSelected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_roleSelectedKey) ?? false;
  }
  static Future<void> adminsave({
    required String role,
  })async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
  }

  /// Get Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adminLoggedIn) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_adminLoggedIn);
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adminLoggedIn, value);
  }

  /// Get User Name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id")?.toString();
  }

  /// Clear Session (Logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Check if gift already opened
  static Future<bool> isGiftOpened() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_giftOpenedKey) ?? false;
  }

  /// Mark gift as opened
  static Future<void> setGiftOpened() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_giftOpenedKey, true);
  }


}