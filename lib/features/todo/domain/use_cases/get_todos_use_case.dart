import '../models/todo.dart';
import '../../data/todo_repository.dart';

class GetTodosUseCase {
  final TodoRepository _repository;

  GetTodosUseCase(this._repository);

  Future<List<Todo>> execute() {
    return _repository.getTodos();
  }
}
