import '../domain/models/category.dart';
import 'datasources/local_category_data_source.dart';

class CategoryRepository {
  final LocalCategoryDataSource _localDataSource;

  CategoryRepository(this._localDataSource);

  Future<List<Category>> getCategories() async {
    return _localDataSource.getCategories();
  }

  Future<void> addCategory(Category category) async {
    await _localDataSource.saveCategory(category);
  }

  Future<void> updateCategory(Category category) async {
    await _localDataSource.updateCategory(category);
  }

  Future<void> deleteCategory(String id) async {
    await _localDataSource.deleteCategory(id);
  }
}
