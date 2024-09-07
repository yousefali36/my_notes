import 'package:flutter/material.dart';

class NoteDetailScreen extends StatelessWidget {
  final Map<String, String> note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPin;
  final VoidCallback onPinToStatusBar;

  NoteDetailScreen({
    required this.note,
    required this.onEdit,
    required this.onDelete,
    required this.onPin,
    required this.onPinToStatusBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note['title']!),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,  // Trigger edit action
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
          IconButton(
            icon: Icon(Icons.push_pin),
            onPressed: onPin,
          ),
          IconButton(
            icon: Icon(Icons.push_pin_outlined),
            onPressed: onPinToStatusBar,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(note['content']!),
      ),
    );
  }
}
