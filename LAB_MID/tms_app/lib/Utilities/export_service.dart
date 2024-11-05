import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:tms_app/Models/task_model.dart';

class ExportService {
  // Method to export tasks to CSV
  Future<void> exportToCSV(List<Task> tasks) async {
    List<List<String>> rows = [
      ['Title', 'Description', 'Due Date', 'Completed']
    ];

    for (var task in tasks) {
      rows.add([
        task.title,
        task.description,
        task.dueDate.toLocal().toString(), // Format date as needed
        task.isCompleted ? 'Yes' : 'No',
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/tasks.csv";
    final file = File(path);
    await file.writeAsString(csvData);
    print("Exported to CSV: $path");
  }

  // Method to export tasks to PDF
  Future<void> exportToPDF(List<Task> tasks) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Tasks List', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  ['Title', 'Description', 'Due Date', 'Completed'],
                  ...tasks.map((task) => [
                    task.title,
                    task.description,
                    task.dueDate.toLocal().toString(), // Format date as needed
                    task.isCompleted ? 'Yes' : 'No',
                  ])
                ],
              ),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/tasks.pdf";
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    print("Exported to PDF: $path");
  }

  // Method to send tasks via email
  Future<void> sendTasksByEmail(List<Task> tasks) async {
    String taskList = "Tasks List:\n\n";

    for (var task in tasks) {
      taskList += "Title: ${task.title}\n";
      taskList += "Description: ${task.description}\n";
      taskList += "Due Date: ${task.dueDate.toLocal().toString()}\n";
      taskList += "Completed: ${task.isCompleted ? 'Yes' : 'No'}\n\n";
    }

    final Email email = Email(
      body: taskList,
      subject: 'Your Task List',
      recipients: ['recipient@example.com'], // Change to recipient's email
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      print("Email sent successfully.");
    } catch (error) {
      print("Error sending email: $error");
    }
  }
}
