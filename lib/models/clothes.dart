import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Clothes {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String category;

  Clothes({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory Clothes.fromMap(Map<String, dynamic> data, String documentId) {
    return Clothes(
      id: documentId,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Clothes(id: $id, name: $name, price: $price, category: $category)';
  }

  static void fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}
}
