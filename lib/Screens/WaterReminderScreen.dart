import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:math';

class WaterReminderScreen extends StatefulWidget {
  @override
  _WaterReminderScreenState createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int _reminderInterval = 45; // Default reminder interval in minutes
  Timer? _timer;
  bool _isRunning = false;

  final List<String> funnyMessages = [
    "Water called. It said you're ghosting it again. Time to hydrate!",
    "You know what's cool? Drinking water. You know what's not? Dehydration. Your call.",
    "Your organs just filed a complaint: ‘Severely Underwatered.’ Fix it!",
    "Are you waiting for a personal invitation? Fine. *DRINK WATER NOW!*",
    "Hydration = Power. Dehydration = Sad, wrinkly raisin. Choose wisely.",
    "Be like a fish. Well, not exactly. Just drink some water, genius!",
    "Water wants to be inside you. No, not in a weird way. Just drink it.",
    "Newsflash: Coffee and soda don’t count. Drink actual water, you rebel.",
    "Guess what? That headache isn’t from ‘life problems’—it’s dehydration!",
    "Your body is 60% water. Don’t make it 40% stubbornness. Hydrate!",
  ];

  String getRandomMessage() {
    final random = Random();
    return funnyMessages[random.nextInt(funnyMessages.length)];
  }

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request notification permission
    final androidPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    androidPlugin?.requestNotificationsPermission();
  }

  void _startReminder() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _scheduleNotification();
    _timer = Timer.periodic(Duration(minutes: _reminderInterval), (timer) {
      _scheduleNotification();
    });
  }

  void _scheduleNotification() async {
    int notificationId = Random().nextInt(100000); // Unique notification ID

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'water_reminder_channel',
      'Water Reminder',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      'Time to Drink Water!',
      getRandomMessage(),
      notificationDetails,
    );
  }

  void _stopReminder() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _showIntervalPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 40), // Placeholder for spacing
                    Text(
                      'Select Reminder Interval',
                      style: TextStyle(fontSize: 24),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Done',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListWheelScrollView(
                  itemExtent: 50,
                  children: List.generate(24, (index) {
                    return Center(
                      child: Text(
                        '${(index + 1) * 5} min',
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                  }),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _reminderInterval = (index + 1) * 5;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showIntervalPicker, // Open modal on tap
              child: Column(
                children: [
                  Text('Water Reminder Interval',
                      style: TextStyle(fontSize: 24)),
                  SizedBox(height: 10),
                  Text('Tap the timer below to change',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 10),
                  Text('$_reminderInterval min',
                      style: TextStyle(fontSize: 48)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startReminder,
                  child: Text('Start'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopReminder,
                  child: Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
