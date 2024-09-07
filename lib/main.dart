// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/notes_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
