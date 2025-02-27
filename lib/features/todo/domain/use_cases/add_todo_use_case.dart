import '../models/todo.dart';
import '../../data/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository _repository;

  AddTodoUseCase(this._repository);

  Future<void> execute(Todo todo) {
    return _repository.addTodo(todo);
  }
}
