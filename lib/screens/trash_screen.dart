import 'package:flutter/material.dart';

class TrashScreen extends StatelessWidget {
  final List<Map<String, String>> trash;
  final Function(int) onRestore;
  final Function(int) onDelete;

  TrashScreen({
    required this.trash,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trash'),
      ),
      body: trash.isEmpty
          ? Center(child: Text('No deleted notes'))
          : ListView.builder(
              itemCount: trash.length,
              itemBuilder: (context, index) {
                final note = trash[index];
                return ListTile(
                  title: Text(note['title']!.isEmpty ? 'Untitled Note' : note['title']!),
                  subtitle: Text(note['content']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.restore),
                        onPressed: () => onRestore(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () => onDelete(index),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
