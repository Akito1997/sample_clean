import '../../../todo/domain/models/todo.dart';
import '../../../todo/domain/models/category.dart';

class TodoDto {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final Priority priority;
  final String? categoryId;

  TodoDto({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
    this.priority = Priority.medium,
    this.categoryId,
  });

  // Convert DTO to Domain model
  Todo toDomain() {
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      dueDate: dueDate,
      priority: priority,
    );
  }

  // Convert Domain model to DTO
  factory TodoDto.fromDomain(Todo todo) {
    return TodoDto(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt,
      dueDate: todo.dueDate,
      priority: todo.priority,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.index,
      'categoryId': categoryId,
    };
  }

  factory TodoDto.fromJson(Map<String, dynamic> json) {
    return TodoDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      priority: Priority.values[json['priority'] as int],
      categoryId: json['categoryId'] as String?,
    );
  }
}
