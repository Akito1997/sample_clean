import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/category.dart';
import '../providers/todo_providers.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('カテゴリ一覧'),
      ),
      body: categoriesAsync.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: category.color,
              ),
              title: Text(category.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteCategory(context, ref, category.id),
              ),
              onTap: () => _editCategory(context, ref, category),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新しいカテゴリ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'カテゴリ名',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple,
                Colors.orange,
              ]
                  .map((color) => GestureDetector(
                        onTap: () {
                          selectedColor = color;
                          Navigator.pop(context);
                          _showAddCategoryDialog(context, ref);
                        },
                        child: CircleAvatar(
                          backgroundColor: color,
                          child: selectedColor == color
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final category = Category(
                  id: DateTime.now().toString(),
                  name: nameController.text,
                  color: selectedColor,
                );
                ref.read(categoryRepositoryProvider).addCategory(category);
                ref.invalidate(categoriesProvider);
                Navigator.pop(context);
              }
            },
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }

  void _editCategory(BuildContext context, WidgetRef ref, Category category) {
    final nameController = TextEditingController(text: category.name);
    Color selectedColor = category.color;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('カテゴリを編集'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'カテゴリ名',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple,
                Colors.orange,
              ]
                  .map((color) => GestureDetector(
                        onTap: () {
                          selectedColor = color;
                          Navigator.pop(context);
                          _editCategory(
                              context, ref, category.copyWith(color: color));
                        },
                        child: CircleAvatar(
                          backgroundColor: color,
                          child: selectedColor == color
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final updatedCategory = Category(
                  id: category.id,
                  name: nameController.text,
                  color: selectedColor,
                );
                ref
                    .read(categoryRepositoryProvider)
                    .updateCategory(updatedCategory);
                ref.invalidate(categoriesProvider);
                Navigator.pop(context);
              }
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('カテゴリを削除'),
        content: const Text('このカテゴリを削除してもよろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              ref.read(categoryRepositoryProvider).deleteCategory(id);
              ref.invalidate(categoriesProvider);
              Navigator.pop(context);
            },
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
}
