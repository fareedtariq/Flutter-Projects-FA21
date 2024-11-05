class Task {
  final int? id; // Nullable to allow for auto-increment
  final String title;
  final String description;
  final DateTime dueDate;
  final int repeatInterval;
  final bool isCompleted;
  final bool isRepeated;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.repeatInterval = 0,
    this.isCompleted = false,
    this.isRepeated = false,
  });

  // Factory method to create a Task from a map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      repeatInterval: map['repeatInterval'],
      isCompleted: map['isCompleted'] == 1,
      isRepeated: map['isRepeated'] == 1,
    );
  }

  // Convert a Task to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'repeatInterval': repeatInterval,
      'isCompleted': isCompleted ? 1 : 0,
      'isRepeated': isRepeated ? 1 : 0,
    };
  }
}
