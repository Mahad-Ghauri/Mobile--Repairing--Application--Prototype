import 'dart:convert';

class Shop {
  final int? id;
  final String name;
  final String address;
  final String phone;
  final String description;
  final String imageUrl;
  final double rating;
  final List<String> services;
  final String ownerId;
  final bool isVerified;

  Shop({
    this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.services,
    required this.ownerId,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'services': services,
      'ownerId': ownerId,
      'isVerified': isVerified,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      phone: map['phone'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      rating: map['rating']?.toDouble() ?? 0.0,
      services: List<String>.from(map['services'] ?? []),
      ownerId: map['ownerId'],
      isVerified: map['isVerified'] ?? false,
    );
  }

  factory Shop.fromJson(String source) {
    return Shop.fromMap(jsonDecode(source));
  }
}