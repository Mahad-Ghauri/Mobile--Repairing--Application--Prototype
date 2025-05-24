import 'dart:convert';

class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      role: map['role'],
    );
  }

  factory User.fromJson(String source) {
    return User.fromMap(jsonDecode(source));
  }
}
