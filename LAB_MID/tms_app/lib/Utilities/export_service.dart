import 'package:csv/csv.dart';
import 'package:tms_app/models/task_model.dart';

class ExportService {
  Future<void> exportToCSV(List<Task> tasks) async {
    List<List<String>> rows = [
      ['ID', 'Title', 'Description', 'Due Date', 'Completed']
    ];

    for (var task in tasks) {
      rows.add([
        task.id?.toString() ?? '',                // Convert nullable int to String or empty string if null
        task.title ?? 'Untitled Task',            // Provide default text if title is null
        task.description ?? 'No Description',     // Provide default text if description is null
        task.dueDate.toIso8601String(),           // DateTime is usually not nullable; adjust if necessary
        task.isCompleted ? 'Yes' : 'No'           // Boolean check for completed status
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    // Add logic to save or share the generated CSV file, e.g., write to a file or share using share package
  }
}
