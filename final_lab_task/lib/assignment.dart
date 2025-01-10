class Assignment {
  String id;
  String title;
  DateTime deadline;

  Assignment({required this.id, required this.title, required this.deadline});

  // Convert Assignment to Firestore document format
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'deadline': deadline.toIso8601String(),
    };
  }

  // Create Assignment from Firestore document
  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      title: map['title'],
      deadline: DateTime.parse(map['deadline']),
    );
  }
}
