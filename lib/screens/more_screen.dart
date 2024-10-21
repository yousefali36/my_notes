// lib/screens/more_screen.dart
import 'package:flutter/material.dart';
import 'trash_screen.dart';

class MoreScreen extends StatefulWidget {
  final VoidCallback onToggleDarkMode;
  final bool isDarkMode;
  List<Map<String, String>> trash; // Change this line to make it mutable
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
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
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
                    trash: widget.trash, // Use the mutable trash list
                    onDelete: widget.onDelete,
                    onRestore: widget.onRestore,
                    onRefresh: () async {
                      // Fetch updated trash data
                      widget.trash = await fetchUpdatedTrashData(); // Update trash data
                      setState(() {}); // Trigger rebuild
                    },
                  )),
                );
              },
              child: Text('Trash'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.onToggleDarkMode,
              child: Text(widget.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode'),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, String>>> fetchUpdatedTrashData() async {
    // Implement your logic to fetch updated trash data here
    // For example, you might want to fetch it from Firestore
    return []; // Return the updated trash data
  }
}
