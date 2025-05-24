import 'dart:convert';
import 'package:mobile_repairing_application__prototype/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _userKey = 'current_user';
  static const String _userTypeKey = 'user_type';
  static const String _isLoggedInKey = 'is_logged_in';

  User? _currentUser;
  bool _isLoggedIn = false;
  String? _userType;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  String? get userType => _userType;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    _userType = prefs.getString(_userTypeKey);

    if (_isLoggedIn) {
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        try {
          final Map<String, dynamic> userMap = jsonDecode(userJson);
          _currentUser = User.fromMap(userMap);
        } catch (e) {
          print('Error parsing user data: $e');
        }
      }
    }
  }

  Future<void> setSession(User user, String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toMap()));
    await prefs.setString(_userTypeKey, userType);
    await prefs.setBool(_isLoggedInKey, true);

    _currentUser = user;
    _userType = userType;
    _isLoggedIn = true;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_userTypeKey);
    await prefs.setBool(_isLoggedInKey, false);

    _currentUser = null;
    _userType = null;
    _isLoggedIn = false;
  }

  bool isTechnician() {
    return _userType == 'technician';
  }

  bool isUser() {
    return _userType == 'user';
  }
}
