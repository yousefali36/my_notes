// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/notes_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';  // Import the package

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize settings for Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Initialize settings for iOS
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  // Initialize settings for both platforms
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        selectNotification(response.payload);
      });

  runApp(MyApp());
}

// Handle notification tap
Future selectNotification(String? payload) async {
  if (payload != null) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => NotesScreen(
          initialNoteId: payload,
        ),
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      navigatorKey: navigatorKey,  // Set the navigator key
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesScreen(),
      debugShowCheckedModeBanner: false,  // Remove the debug banner
    );
  }
}
