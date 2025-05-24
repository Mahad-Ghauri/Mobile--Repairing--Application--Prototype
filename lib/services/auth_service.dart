import 'package:mobile_repairing_application__prototype/models/user_model.dart';
import 'package:mobile_repairing_application__prototype/services/database_service.dart';

class AuthService {
  final DatabaseService _dbService = DatabaseService();

  // Sign up a new user
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      // Check if user already exists
      final existingUser = await _dbService.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('User with this email already exists');
      }

      // Create new user
      final userId = await _dbService.createUser({
        'name': name,
        'email': email,
        'password':
            password, // Note: In a real app, you should hash the password
        'phone': phone,
        'role': role,
      });

      // Get the created user
      final userMap = await _dbService.getUserByEmail(email);
      if (userMap != null) {
        return User.fromMap(userMap);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // Login user
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userMap = await _dbService.getUserByEmail(email);

      if (userMap == null) {
        throw Exception('User not found');
      }

      // In a real app, you should compare hashed passwords
      if (userMap['password'] != password) {
        throw Exception('Invalid password');
      }

      return User.fromMap(userMap);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Check if user exists
  Future<bool> userExists(String email) async {
    try {
      final user = await _dbService.getUserByEmail(email);
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
