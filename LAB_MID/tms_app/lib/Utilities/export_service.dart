import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:tms_app/Models/task_model.dart';

class ExportService {
  Future<void> exportToCSV(List<Task> tasks) async {
    List<List<String>> rows = [
      ['Title', 'Description', 'Due Date', 'Completed']
    ];

    for (var task in tasks) {
      rows.add([
        task.title,
        task.description,
        task.dueDate,
        task.isCompleted ? 'Yes' : 'No',
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/tasks.csv";
    final file = File(path);
    await file.writeAsString(csvData);
  }
}
