// lib/screens/more_screen.dart
import 'package:flutter/material.dart';
import 'trash_screen.dart';

class MoreScreen extends StatelessWidget {
  final VoidCallback onToggleDarkMode;
  final bool isDarkMode;
  final List<Map<String, String>> trash;
  final Function(int) onDelete;
  final Function(int) onRestore;

  MoreScreen({
    required this.onToggleDarkMode,
    required this.isDarkMode,
    required this.trash,
    required this.onDelete,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Options'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrashScreen(
                    trash: trash,
                    onDelete: onDelete,
                    onRestore: onRestore,
                  )),
                );
              },
              child: Text('Trash'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onToggleDarkMode,
              child: Text(isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
