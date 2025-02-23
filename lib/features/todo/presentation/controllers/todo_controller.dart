import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/todo.dart';
import '../../data/todo_repository.dart';
import '../../domain/use_cases/get_todos_use_case.dart';
import '../../domain/errors/todo_errors.dart';

class TodoController extends StateNotifier<AsyncValue<List<Todo>>> {
  final TodoRepository _repository;
  final GetTodosUseCase _getTodosUseCase;

  TodoController(this._repository, this._getTodosUseCase)
      : super(const AsyncValue.loading()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    state = const AsyncValue.loading();
    try {
      final todos = await _getTodosUseCase.execute();
      state = AsyncValue.data(todos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTodo(
    String title,
    String description, {
    DateTime? dueDate,
    Priority priority = Priority.medium,
    String? categoryId,
  }) async {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: priority,
      categoryId: categoryId,
    );

    await _repository.addTodo(todo);
    await loadTodos();
  }

  Future<void> updateTodoCategory(String todoId, String? categoryId) async {
    final currentState = state;
    if (currentState is AsyncData && currentState.value != null) {
      final todo = currentState.value!.firstWhere(
        (t) => t.id == todoId,
        orElse: () => throw TodoNotFoundFailure(),
      );
      final updatedTodo = todo.copyWith(categoryId: categoryId);
      await _repository.updateTodo(updatedTodo);
      await loadTodos();
    }
  }

  Future<void> toggleTodo(Todo todo) async {
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    await _repository.updateTodo(updatedTodo);
    await loadTodos();
  }

  Future<void> deleteTodo(String id) async {
    await _repository.deleteTodo(id);
    await loadTodos();
  }
}
