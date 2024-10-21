import 'package:flutter/material.dart';

class TrashScreen extends StatelessWidget {
  final List<Map<String, dynamic>> trash;
  final Function(int) onRestore;
  final Function(int) onDelete;
  final Future<void> Function() onRefresh;

  TrashScreen({
    required this.trash,
    required this.onRestore,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trash'),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: trash.isEmpty
            ? Center(child: Text('No deleted notes'))
            : ListView.builder(
                itemCount: trash.length,
                itemBuilder: (context, index) {
                  final note = trash[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
                        note['title']!.isEmpty ? 'Untitled Note' : note['title']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(note['content'] ?? ''),
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
                    ),
                  );
                },
              ),
      ),
    );
  }
}
