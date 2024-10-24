import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  final String title;
  final String date;
  final String content;
  final bool isPinned;
<<<<<<< HEAD
  final bool isStatusBarPinned;
  final VoidCallback onTap;
=======
  final VoidCallback onTap;  // Add this line
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
  final VoidCallback onPin;
  final VoidCallback onUnpin;
  final VoidCallback onDelete;
  final VoidCallback onPinToStatusBar;

  NoteTile({
    required this.title,
    required this.date,
    required this.content,
    required this.isPinned,
<<<<<<< HEAD
    required this.isStatusBarPinned,
    required this.onTap,
=======
    required this.onTap,  // Add this line
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
    required this.onPin,
    required this.onUnpin,
    required this.onDelete,
    required this.onPinToStatusBar,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      child: ListTile(
        onTap: onTap,
        title: Text(
          title.isEmpty ? 'Untitled Note' : title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(content),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isPinned ? Icons.pin_drop : Icons.pin_drop_outlined),
              onPressed: isPinned ? onUnpin : onPin,
            ),
            IconButton(
              icon: Icon(
                isStatusBarPinned ? Icons.push_pin : Icons.push_pin_outlined,
              ),
              onPressed: onPinToStatusBar,
            ),
          ],
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
      ),
=======
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
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
    );
  }
}
