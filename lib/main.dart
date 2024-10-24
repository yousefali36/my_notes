<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'screens/notes_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'firebase_options.dart'; // Import the generated Firebase options

// Initialize the Flutter Local Notifications Plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  // Initialize the local notifications plugin
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
          onToggleThemeMode: () {}, // Add the required argument
        ),
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleThemeMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

=======
// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/notes_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
<<<<<<< HEAD
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: NotesScreen(onToggleThemeMode: _toggleThemeMode),
=======
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesScreen(),
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
      debugShowCheckedModeBanner: false,
    );
  }
}
