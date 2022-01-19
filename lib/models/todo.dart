const tableTodos = 'todos';

class TodoFields {
  static final List<String> values = [
    /// Add all fields
    id, todoName, todoDescription, todoTime, todoStatus
  ];

  static const String id = '_id';
  static const String todoName = 'todoName';
  static const String todoDescription = 'todoDescription';
  static const String todoTime = 'todoTime';
  static const String todoStatus = 'todoStatus';
}

class Todo {
   int? id;
   String todoName;
   String todoDescription;
   String todoStatus;
   DateTime todoTime;

   Todo({
    this.id,
    required this.todoName,
    required this.todoDescription,
    required this.todoTime,
    required this.todoStatus,
  });

  Todo copy({
    int? id,
    String? todoName,
    String? todoDescription,
    String? todoStatus,
    DateTime? todoTime,
  }) =>
      Todo(
        id: id ?? this.id,
        todoName: todoName ?? this.todoName,
        todoDescription: todoDescription ?? this.todoDescription,
        todoStatus: todoStatus ?? this.todoStatus,
        todoTime: todoTime ?? this.todoTime,
      );

  static Todo fromJson(Map<String, Object?> json) => Todo(
        id: json[TodoFields.id] as int?,
        todoName: json[TodoFields.todoName] as String,
        todoDescription: json[TodoFields.todoDescription] as String,
        todoStatus: json[TodoFields.todoStatus] as String,
        todoTime: DateTime.parse(json[TodoFields.todoTime] as String),
      );

  Map<String, Object?> toJson() => {
        TodoFields.id: id,
        TodoFields.todoName: todoName,
        TodoFields.todoDescription: todoDescription,
        TodoFields.todoStatus: todoStatus,
        TodoFields.todoTime: todoTime.toIso8601String(),
      };
}
