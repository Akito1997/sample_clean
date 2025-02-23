import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/todo_repository.dart';
import '../../domain/models/todo.dart';
import '../../domain/models/category.dart';
import '../../domain/use_cases/get_todos_use_case.dart';
import '../controllers/todo_controller.dart';
import '../../data/datasources/local_todo_data_source.dart';
import '../../data/category_repository.dart';
import '../../data/datasources/local_category_data_source.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Should be overridden in main.dart');
});

final localTodoDataSourceProvider = Provider<LocalTodoDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalTodoDataSourceImpl(prefs);
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final localDataSource = ref.watch(localTodoDataSourceProvider);
  return TodoRepository(localDataSource);
});

final getTodosUseCaseProvider = Provider<GetTodosUseCase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodosUseCase(repository);
});

final todoControllerProvider =
    StateNotifierProvider<TodoController, AsyncValue<List<Todo>>>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  final getTodosUseCase = ref.watch(getTodosUseCaseProvider);
  return TodoController(repository, getTodosUseCase);
});

final localCategoryDataSourceProvider =
    Provider<LocalCategoryDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalCategoryDataSourceImpl(prefs);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final localDataSource = ref.watch(localCategoryDataSourceProvider);
  return CategoryRepository(localDataSource);
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategories();
});
