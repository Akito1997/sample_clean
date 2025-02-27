import '../models/todo.dart';
import '../../data/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository _repository;

  UpdateTodoUseCase(this._repository);

  Future<void> execute(Todo todo) {
    return _repository.updateTodo(todo);
  }
}
