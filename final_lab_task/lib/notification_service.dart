import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'assignment.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz_data.initializeTimeZones();  // Initialize time zones

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');  // Replace 'app_icon' with your app icon name

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show the deadline reminder notification
  Future<void> showDeadlineReminder(Assignment assignment) async {
    // Convert DateTime to TZDateTime
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(
        assignment.deadline.subtract(Duration(minutes: 30)), tz.local);

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'deadline_channel',
        'Assignment Deadlines',
        importance: Importance.max,
        priority: Priority.high,
        // No need for androidAllowWhileIdle here
      ),
    );

    // Schedule the notification to fire 30 minutes before the deadline
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Assignment Deadline',
      'Deadline for ${assignment.title} is approaching!',
      scheduledTime, // Schedule time converted to TZDateTime
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.exact,  // Exact mode to trigger at scheduled time
    );
  }
}
