import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/category.dart';

abstract class LocalCategoryDataSource {
  Future<List<Category>> getCategories();
  Future<void> saveCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<void> updateCategory(Category category);
}

class LocalCategoryDataSourceImpl implements LocalCategoryDataSource {
  final SharedPreferences _prefs;
  static const String _categoriesKey = 'categories';

  LocalCategoryDataSourceImpl(this._prefs);

  @override
  Future<List<Category>> getCategories() async {
    final categoriesJson = _prefs.getStringList(_categoriesKey) ?? [];
    return categoriesJson.map((json) {
      final map = jsonDecode(json);
      return Category(
        id: map['id'],
        name: map['name'],
        color: Color(map['color']),
      );
    }).toList();
  }

  @override
  Future<void> saveCategory(Category category) async {
    final categories = await getCategories();
    categories.add(category);
    await _saveCategories(categories);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final categories = await getCategories();
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      categories[index] = category;
      await _saveCategories(categories);
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    final categories = await getCategories();
    categories.removeWhere((category) => category.id == id);
    await _saveCategories(categories);
  }

  Future<void> _saveCategories(List<Category> categories) async {
    final categoriesJson = categories
        .map((category) => jsonEncode({
              'id': category.id,
              'name': category.name,
              'color': category.color.value,
            }))
        .toList();
    await _prefs.setStringList(_categoriesKey, categoriesJson);
  }
}
