class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final Priority priority;
  final String? categoryId;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = Priority.medium,
    this.categoryId,
  });

  Todo copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    Priority? priority,
    String? categoryId,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}

enum Priority { low, medium, high }
