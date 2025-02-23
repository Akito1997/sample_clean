import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.color,
  });

  Category copyWith({
    String? name,
    Color? color,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
}
