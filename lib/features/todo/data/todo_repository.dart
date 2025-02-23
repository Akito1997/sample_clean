import '../domain/models/todo.dart';
import 'models/todo_dto.dart';
import 'datasources/local_todo_data_source.dart';

class TodoRepository {
  final LocalTodoDataSource _localDataSource;

  TodoRepository(this._localDataSource);

  Future<List<Todo>> getTodos() async {
    final todoDtos = await _localDataSource.getTodos();
    return todoDtos.map((dto) => dto.toDomain()).toList();
  }

  Future<void> addTodo(Todo todo) async {
    await _localDataSource.saveTodo(TodoDto.fromDomain(todo));
  }

  Future<void> updateTodo(Todo todo) async {
    await _localDataSource.updateTodo(TodoDto.fromDomain(todo));
  }

  Future<void> deleteTodo(String id) async {
    await _localDataSource.deleteTodo(id);
  }
}
