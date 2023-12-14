import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> tasks = ['Task 1', 'Task 2', 'Task 3'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle notification tap
    // You can navigate to a specific screen or perform other actions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTaskDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTaskDialog() async {
    String newTask = '';
    TimeOfDay selectedTime = TimeOfDay.now();

    await showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Task'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  newTask = value;
                },
                decoration: InputDecoration(labelText: 'Task'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );

                  if (pickedTime != null && pickedTime != selectedTime) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                child: Text('Select Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newTask.isNotEmpty) {
                  setState(() {
                    tasks.add('$newTask at ${selectedTime.format(context)}');
                  });

                  await _scheduleNotification(
                    '$newTask Reminder',
                    'Don\'t forget to do $newTask!',
                    selectedTime,
                  );
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _scheduleNotification(
    String title,
    String body,
    TimeOfDay scheduledTime,
  ) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      channelShowBadge: false,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    var now = DateTime.now();
    var scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
