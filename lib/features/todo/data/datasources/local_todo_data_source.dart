import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_dto.dart';

abstract class LocalTodoDataSource {
  Future<List<TodoDto>> getTodos();
  Future<void> saveTodo(TodoDto todo);
  Future<void> deleteTodo(String id);
  Future<void> updateTodo(TodoDto todo);
}

class LocalTodoDataSourceImpl implements LocalTodoDataSource {
  final SharedPreferences _prefs;
  static const String _todosKey = 'todos';

  LocalTodoDataSourceImpl(this._prefs);

  @override
  Future<List<TodoDto>> getTodos() async {
    final todosJson = _prefs.getStringList(_todosKey) ?? [];
    return todosJson.map((json) => TodoDto.fromJson(jsonDecode(json))).toList();
  }

  @override
  Future<void> saveTodo(TodoDto todo) async {
    final todos = await getTodos();
    todos.add(todo);
    await _saveTodos(todos);
  }

  @override
  Future<void> updateTodo(TodoDto todo) async {
    final todos = await getTodos();
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos[index] = todo;
      await _saveTodos(todos);
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = await getTodos();
    todos.removeWhere((todo) => todo.id == id);
    await _saveTodos(todos);
  }

  Future<void> _saveTodos(List<TodoDto> todos) async {
    final todosJson = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await _prefs.setStringList(_todosKey, todosJson);
  }
}
