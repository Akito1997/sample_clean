import '../../data/todo_repository.dart';
import '../models/todo.dart';

class SearchTodosUseCase {
  final TodoRepository _repository;

  SearchTodosUseCase(this._repository);

  Future<List<Todo>> execute(String query) async {
    final todos = await _repository.getTodos();
    return todos
        .where((todo) =>
            todo.title.toLowerCase().contains(query.toLowerCase()) ||
            todo.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
