class Assignment {
  String id;
  String title;
  DateTime deadline;
  String? filePath; // Optional filePath to store the attached document

  Assignment({
    required this.id,
    required this.title,
    required this.deadline,
    this.filePath, // filePath is optional
  });

  // Convert Assignment to Firestore document format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'deadline': deadline.toIso8601String(),
      'filePath': filePath, // Include filePath in Firestore document
    };
  }

  // Create Assignment from Firestore document
  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      title: map['title'],
      deadline: DateTime.parse(map['deadline']),
      filePath: map['filePath'], // Retrieve filePath from Firestore document
    );
  }
}
