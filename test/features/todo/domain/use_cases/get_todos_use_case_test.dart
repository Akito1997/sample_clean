import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sample/features/todo/data/todo_repository.dart';
import 'package:sample/features/todo/domain/models/todo.dart';
import 'package:sample/features/todo/domain/use_cases/get_todos_use_case.dart';
import 'get_todos_use_case_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late MockTodoRepository mockRepository;
  late GetTodosUseCase useCase;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = GetTodosUseCase(mockRepository);
  });

  test('should get todos from repository', () async {
    // Arrange
    final todos = [
      Todo(
        id: '1',
        title: 'Test',
        description: '',
        createdAt: DateTime.now(),
        priority: Priority.medium,
      ),
    ];
    when(mockRepository.getTodos()).thenAnswer((_) async => todos);

    // Act
    final result = await useCase.execute();

    // Assert
    expect(result, equals(todos));
    verify(mockRepository.getTodos()).called(1);
  });
}
