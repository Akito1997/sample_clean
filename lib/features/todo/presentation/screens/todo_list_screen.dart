import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/features/todo/domain/models/todo.dart';
import '../widgets/todo_list_item.dart';
import '../providers/todo_providers.dart';
import '../screens/category_list_screen.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosState = ref.watch(todoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryListScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: todosState.when(
        data: (todos) => ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return TodoListItem(todo: todo);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDueDate;
    Priority selectedPriority = Priority.medium;
    String? selectedCategoryId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('新しいToDo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'タイトル',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: '説明',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('期限: '),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDueDate = date;
                          });
                        }
                      },
                      child: Text(
                        selectedDueDate != null
                            ? '${selectedDueDate!.year}/${selectedDueDate!.month}/${selectedDueDate!.day}'
                            : '選択してください',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('優先度: '),
                    DropdownButton<Priority>(
                      value: selectedPriority,
                      items: Priority.values
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p.toString().split('.').last),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPriority = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, _) {
                    final categoriesAsync = ref.watch(categoriesProvider);
                    return categoriesAsync.when(
                      data: (categories) => Row(
                        children: [
                          const Text('カテゴリ: '),
                          DropdownButton<String?>(
                            value: selectedCategoryId,
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('なし'),
                              ),
                              ...categories.map(
                                (c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: c.color,
                                        radius: 8,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(c.name),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedCategoryId = value;
                              });
                            },
                          ),
                        ],
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('カテゴリの読み込みに失敗しました'),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  ref.read(todoControllerProvider.notifier).addTodo(
                        titleController.text,
                        descriptionController.text,
                        dueDate: selectedDueDate,
                        priority: selectedPriority,
                        categoryId: selectedCategoryId,
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}
