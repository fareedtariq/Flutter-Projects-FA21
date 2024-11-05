class Task {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  String repeat; // Stores repeat settings (e.g., 'daily', 'weekly')
  List<Subtask> subtasks; // List of subtasks for progress tracking
  int notificationId; // ID for managing notifications

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.repeat = 'none', // Default to no repetition
    this.subtasks = const [], // Initialize as an empty list
    this.notificationId = 0,
  });

  // Calculate progress based on completed subtasks
  double get progress {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    int completedCount = subtasks.where((subtask) => subtask.isCompleted).length;
    return completedCount / subtasks.length;
  }

  // Mark task as completed
  void markAsCompleted() {
    isCompleted = true;
    for (var subtask in subtasks) {
      subtask.isCompleted = true;
    }
  }

  // Toggle repeat settings (e.g., daily or weekly)
  void toggleRepeat(String repeatOption) {
    repeat = repeatOption;
  }

  // Add a subtask
  void addSubtask(String title) {
    subtasks.add(Subtask(title: title));
  }

  // Convert task to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'repeat': repeat,
      'subtasks': subtasks.map((s) => s.toMap()).toList(),
      'notificationId': notificationId,
    };
  }

  // Create task from a map (retrieved from database)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      repeat: map['repeat'],
      subtasks: (map['subtasks'] as List).map((s) => Subtask.fromMap(s)).toList(),
      notificationId: map['notificationId'] ?? 0,
    );
  }

  // Export task details to CSV format for file export
  List<String> toCsvRow() {
    return [
      id.toString(),
      title,
      description,
      dueDate.toIso8601String(),
      isCompleted ? 'Completed' : 'Pending',
      repeat,
      progress.toString(),
    ];
  }
}
void deleteTask(String taskId) {
  // Implement logic to remove task from your data source
}

// Function to mark a task as completed
void markTaskAsCompleted(String taskId) {
  // Implement logic to update the task status to completed
}
// Subtask class for tracking individual subtask progress
class Subtask {
  String title;
  bool isCompleted;

  Subtask({required this.title, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
