abstract class TodoFailure implements Exception {
  String get message;
}

class TodoNotFoundFailure implements TodoFailure {
  @override
  String get message => 'ToDo not found';
}

class TodoValidationFailure implements TodoFailure {
  final String field;

  TodoValidationFailure(this.field);

  @override
  String get message => '$field is invalid';
}
