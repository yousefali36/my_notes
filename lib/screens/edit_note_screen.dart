// lib/screens/edit_note_screen.dart
import 'package:flutter/material.dart';

class EditNoteScreen extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;

  EditNoteScreen({this.initialTitle, this.initialContent});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _contentController = TextEditingController(text: widget.initialContent ?? '');
  }

  @override
<<<<<<< HEAD
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
=======
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title (optional)',
<<<<<<< HEAD
                border: OutlineInputBorder(),
=======
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: 'Note Content',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final content = _contentController.text;

                if (content.isNotEmpty) {
                  Navigator.pop(context, {'title': title, 'content': content});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Content cannot be empty.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
