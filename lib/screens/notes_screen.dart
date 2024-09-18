import 'package:flutter/material.dart';
import 'package:my_notes/screens/more_screen.dart';
import 'edit_note_screen.dart';
import 'calendar_screen.dart';
import '../widgets/note_tile.dart';
import 'notes_search_delegate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class NotesScreen extends StatefulWidget {
  final String? initialNoteId;

  NotesScreen({this.initialNoteId});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  int _selectedIndex = 0;
  List<Map<String, String>> notes = [];
  List<Map<String, String>> trash = [];
  List<Map<String, String>> filteredNotes = [];
  int _notificationIdCounter = 0;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _updateFilteredNotes();

    if (widget.initialNoteId != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _navigateToNoteById(widget.initialNoteId!);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addNote(String? title, String content) {
    setState(() {
      notes.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title ?? '',
        'content': content,
        'date': DateTime.now().toString().substring(0, 10),
        'pinned': 'false',
        'statusBarPinned': 'false',
        'notificationId': _notificationIdCounter.toString(),
      });
      _notificationIdCounter++;
      _updateFilteredNotes();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note added successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _updateNote(int index, String? title, String content) {
    setState(() {
      notes[index] = {
        'id': notes[index]['id']!,
        'title': title ?? '',
        'content': content,
        'date': DateTime.now().toString().substring(0, 10),
        'pinned': notes[index]['pinned'] ?? 'false',
        'statusBarPinned': notes[index]['statusBarPinned'] ?? 'false',
        'notificationId': notes[index]['notificationId']!,
      };
      _updateFilteredNotes();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note updated successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _pinNote(int index) {
    setState(() {
      notes[index]['pinned'] = 'true';
      _updateFilteredNotes();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note pinned'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _unpinNote(int index) {
    setState(() {
      notes[index]['pinned'] = 'false';
      _updateFilteredNotes();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note unpinned'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _pinToStatusBar(int index) async {
    bool isPinned = notes[index]['statusBarPinned'] == 'true';
    int notificationId = int.parse(notes[index]['notificationId']!);

    if (!isPinned) {
      await _showNotification(
        notificationId,
        notes[index]['title']!.isEmpty ? 'Untitled Note' : notes[index]['title']!,
        notes[index]['content']!,
      );
      setState(() {
        notes[index]['statusBarPinned'] = 'true';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pinned to Status Bar'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      await flutterLocalNotificationsPlugin.cancel(notificationId);
      setState(() {
        notes[index]['statusBarPinned'] = 'false';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unpinned from Status Bar'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    _updateFilteredNotes();
  }

  void _deleteNote(int index) {
    if (notes[index]['statusBarPinned'] == 'true') {
      int notificationId = int.parse(notes[index]['notificationId']!);
      flutterLocalNotificationsPlugin.cancel(notificationId);
    }

    setState(() {
      trash.add(notes[index]);
      notes.removeAt(index);
      _updateFilteredNotes();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note moved to trash'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _restoreNoteFromTrash(int index) {
    setState(() {
      notes.add(trash[index]);
      trash.removeAt(index);
      _updateFilteredNotes();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note restored'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _permanentlyDeleteNoteFromTrash(int index) {
    setState(() {
      trash.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note permanently deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'status_bar_channel',
      'Status Bar Notifications',
      channelDescription: 'Notifications pinned to the status bar',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: id.toString(),
    );
  }

  void _updateFilteredNotes() {
    final pinnedNotes = notes.where((note) => note['pinned'] == 'true').toList();
    final unpinnedNotes = notes.where((note) => note['pinned'] == 'false').toList();
    filteredNotes = pinnedNotes + unpinnedNotes;
  }

  void _navigateToNoteById(String noteId) {
    int index = notes.indexWhere((note) => note['id'] == noteId);
    if (index != -1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(notes[index]['title']!.isEmpty
              ? 'Untitled Note'
              : notes[index]['title']!),
          content: Text(notes[index]['content']!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      NotesScreenBody(
        notes: notes,
        filteredNotes: filteredNotes,
        onAddNote: _addNote,
        onUpdateNote: _updateNote,
        onPinNote: _pinNote,
        onUnpinNote: _unpinNote,
        onDeleteNote: _deleteNote,
        onPinToStatusBar: _pinToStatusBar,
      ),
      CalendarScreen(),
      MoreScreen(
        onToggleDarkMode: _toggleDarkMode,
        isDarkMode: isDarkMode,
        trash: trash,
        onDelete: _permanentlyDeleteNoteFromTrash,
        onRestore: _restoreNoteFromTrash,
      ),
    ];

    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.notes),
              label: 'My Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      debugShowCheckedModeBanner: false,  // Remove the debug banner
    );
  }
}

class NotesScreenBody extends StatelessWidget {
  final List<Map<String, String>> notes;
  final List<Map<String, String>> filteredNotes;
  final Function(String?, String) onAddNote;
  final Function(int, String?, String) onUpdateNote;
  final Function(int) onPinNote;
  final Function(int) onUnpinNote;
  final Function(int) onDeleteNote;
  final Function(int) onPinToStatusBar;

  NotesScreenBody({
    required this.notes,
    required this.filteredNotes,
    required this.onAddNote,
    required this.onUpdateNote,
    required this.onPinNote,
    required this.onUnpinNote,
    required this.onDeleteNote,
    required this.onPinToStatusBar,
  });

  @override
  Widget build(BuildContext context) {
    final pinnedNotes = filteredNotes.where((note) => note['pinned'] == 'true').toList();
    final unpinnedNotes = filteredNotes.where((note) => note['pinned'] == 'false').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NotesSearchDelegate(notes),
              );
            },
          ),
        ],
      ),
      body: filteredNotes.isEmpty
          ? Center(child: Text('No notes available'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  if (pinnedNotes.isNotEmpty)
                    _buildSectionHeader('Pinned Notes'),
                  ...pinnedNotes.map((note) => _buildNoteTile(context, note, notes.indexOf(note))),
                  if (unpinnedNotes.isNotEmpty)
                    _buildSectionHeader('Other Notes'),
                  ...unpinnedNotes.map((note) => _buildNoteTile(context, note, notes.indexOf(note))),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditNoteScreen()),
          );

          if (result != null && result is Map<String, String>) {
            onAddNote(result['title'], result['content']!);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 60, 128, 162),
        ),
      ),
    );
  }

  Widget _buildNoteTile(BuildContext context, Map<String, String> note, int index) {
    return NoteTile(
      title: note['title']!,
      date: note['date']!,
      content: note['content']!,
      isPinned: note['pinned'] == 'true',
      isStatusBarPinned: note['statusBarPinned'] == 'true',
      onPin: () => onPinNote(index),
      onUnpin: () => onUnpinNote(index),
      onDelete: () => onDeleteNote(index),
      onPinToStatusBar: () => onPinToStatusBar(index),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditNoteScreen(
              initialTitle: note['title'],
              initialContent: note['content'],
            ),
          ),
        );

        if (result != null && result is Map<String, String>) {
          onUpdateNote(index, result['title'], result['content']!);
        }
      },
    );
  }
}
