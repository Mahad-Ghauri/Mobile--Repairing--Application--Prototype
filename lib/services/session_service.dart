import 'package:shared_preferences.dart';
import 'package:mobile_repairing_application__prototype/models/user_model.dart';

class SessionService {
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';
  static const String _isLoggedInKey = 'is_logged_in';

  final SharedPreferences _prefs;

  SessionService(this._prefs);

  Future<void> saveSession(User user) async {
    await _prefs.setBool(_isLoggedInKey, true);
    await _prefs.setInt(_userIdKey, user.id!);
    await _prefs.setString(_userNameKey, user.name);
    await _prefs.setString(_userEmailKey, user.email);
    await _prefs.setString(_userRoleKey, user.role);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userRoleKey);
    await _prefs.setBool(_isLoggedInKey, false);
  }

  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;
  
  String? get userRole => _prefs.getString(_userRoleKey);
  
  int? get userId => _prefs.getInt(_userIdKey);
  
  String? get userName => _prefs.getString(_userNameKey);
  
  String? get userEmail => _prefs.getString(_userEmailKey);

  User? get currentUser {
    if (!isLoggedIn) return null;
    
    return User(
      id: userId,
      name: userName ?? '',
      email: userEmail ?? '',
      password: '', // We don't store the password
      phone: '', // We don't store the phone
      role: userRole ?? 'user',
    );
  }
} 