import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/todo.dart';
import '../providers/todo_providers.dart';

class TodoListItem extends ConsumerWidget {
  final Todo todo;

  const TodoListItem({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(todo.title),
      subtitle: Text(todo.description),
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) {
          ref.read(todoControllerProvider.notifier).toggleTodo(todo);
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          ref.read(todoControllerProvider.notifier).deleteTodo(todo.id);
        },
      ),
    );
  }
}
