import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  final String title;
  final String date;
  final String content;
  final bool isPinned;
  final VoidCallback onTap;  // Add this line
  final VoidCallback onPin;
  final VoidCallback onUnpin;
  final VoidCallback onDelete;
  final VoidCallback onPinToStatusBar;

  NoteTile({
    required this.title,
    required this.date,
    required this.content,
    required this.isPinned,
    required this.onTap,  // Add this line
    required this.onPin,
    required this.onUnpin,
    required this.onDelete,
    required this.onPinToStatusBar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,  // Add this line
      title: Text(title.isEmpty ? 'Untitled Note' : title),
      subtitle: Text(content),
      trailing: IconButton(
        icon: Icon(isPinned ? Icons.pin_drop : Icons.pin_drop_outlined),
        onPressed: isPinned ? onUnpin : onPin,
      ),
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.pin_drop),
                title: Text('Pin to Status Bar'),
                onTap: onPinToStatusBar,
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete Note'),
                onTap: onDelete,
              ),
            ],
          ),
        );
      },
    );
  }
}
