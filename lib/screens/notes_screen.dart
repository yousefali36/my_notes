<<<<<<< HEAD
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_notes/screens/more_screen.dart';
import 'package:my_notes/screens/note_detail_screen.dart';
import 'edit_note_screen.dart';
import 'calendar_screen.dart';
import '../widgets/note_tile.dart';
import 'notes_search_delegate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../screens/trash_screen.dart';

class NotesScreen extends StatefulWidget {
  final String? initialNoteId;
  final VoidCallback onToggleThemeMode;

  NotesScreen({this.initialNoteId, required this.onToggleThemeMode});

=======
import 'package:flutter/material.dart';
import 'package:my_notes/screens/more_screen.dart';
import 'edit_note_screen.dart';
import 'calendar_screen.dart';
import '../widgets/note_tile.dart';
import 'notes_search_delegate.dart';  // Ensure this import is correct

class NotesScreen extends StatefulWidget {
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
<<<<<<< HEAD
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> trash = [];
  List<Map<String, dynamic>> filteredNotes = [];
  int _notificationIdCounter = 0;
  bool isDarkMode = false;
  String? _deviceId;
  bool _isLoading = true; // Add a loading state
=======
  int _selectedIndex = 0;
  List<Map<String, String>> notes = [];
  List<Map<String, String>> filteredNotes = [];
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _getDeviceId();
    await _fetchNotesFromFirestore();
    _updateFilteredNotes();
    setState(() {
      _isLoading = false; // Set loading to false after fetching notes
    });

    if (widget.initialNoteId != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _navigateToNoteById(widget.initialNoteId!);
      });
    }
  }

  Future<void> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _deviceId = androidInfo.id; // Android device ID
      });
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      setState(() {
        _deviceId = iosInfo.identifierForVendor; // iOS device ID
      });
    }
=======
    _updateFilteredNotes();
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
<<<<<<< HEAD

    switch (index) {
      case 0:
        // Already on Notes screen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarScreen()),
        );
        break;
      case 2:
        _fetchDeletedNotes(); // Ensure the latest deleted notes are fetched
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrashScreen(
              trash: trash,
              onRestore: _restoreNoteFromTrash,
              onDelete: _permanentlyDeleteNoteFromTrash,
              onRefresh: _fetchDeletedNotes, // Updated to remove async and return type
            ),
          ),
        );
        break;
    }
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    widget.onToggleThemeMode();
  }

  Future<void> _fetchNotesFromFirestore() async {
    if (_deviceId == null) return; // Ensure device ID is available

    try {
      final querySnapshot = await _firestore
          .collection('notes')
          .where('deviceId', isEqualTo: _deviceId) // Filter by device ID
          .where('deleted', isEqualTo: false) // Fetch only non-deleted notes
          .get();
      setState(() {
        notes = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'title': doc['title'] ?? '',
            'content': doc['content'] ?? '',
            'date': doc.data().containsKey('date') ? doc['date'] : 'No Date',
            'pinned': doc.data().containsKey('pinned') ? doc['pinned'] : 'false',
            'statusBarPinned': doc.data().containsKey('statusBarPinned') ? doc['statusBarPinned'] : 'false',
            'notificationId': doc.data().containsKey('notificationId') ? doc['notificationId'] : '',
            'deviceId': doc['deviceId'], // Include device ID
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  void _addNoteToFirestore(String? title, String content) async {
    if (_deviceId == null) return; // Ensure device ID is available

    final newNote = {
      'title': title ?? '',
      'content': content,
      'date': DateTime.now().toString().substring(0, 10),
      'deviceId': _deviceId, // Save device ID
      'pinned': 'false',
      'statusBarPinned': 'false',
      'notificationId': _notificationIdCounter.toString(),
      'deleted': false, // Ensure new notes are not deleted
    };

    // Add the note to Firestore
    final docRef = await _firestore.collection('notes').add(newNote);

    // Add the note to the local list
    setState(() {
      notes.add({
        ...newNote,
        'id': docRef.id, // Add the document ID to the note
      });
      _updateFilteredNotes(); // Update the filtered notes list
    });

    _notificationIdCounter++;
  }

  void _updateNoteInFirestore(String id, String? title, String content) async {
    if (_deviceId == null) return; // Ensure device ID is available

    await _firestore.collection('notes').doc(id).update({
      'title': title ?? '',
      'content': content,
      'date': DateTime.now().toString().substring(0, 10),
      'deviceId': _deviceId, // Ensure device ID is consistent
    });
    _fetchNotesFromFirestore(); // Refresh notes list after update
  }

  void _deleteNoteFromFirestore(String id) async {
    await _firestore.collection('notes').doc(id).update({'deleted': true});
    _fetchNotesFromFirestore();
  }

  void _addNote(String? title, String content) {
    _addNoteToFirestore(title, content);
=======
  }

  void _addNote(String? title, String content) {
    setState(() {
      notes.add({
        'title': title ?? '',
        'content': content,
        'date': DateTime.now().toString().substring(0, 10),
        'pinned': 'false',
      });
      _updateFilteredNotes();
    });

>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note added successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _updateNote(int index, String? title, String content) {
<<<<<<< HEAD
    _updateNoteInFirestore(notes[index]['id']!, title, content);
=======
    setState(() {
      notes[index] = {
        'title': title ?? '',
        'content': content,
        'date': DateTime.now().toString().substring(0, 10),
        'pinned': notes[index]['pinned'] ?? 'false',
      };
      _updateFilteredNotes();
    });

>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
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

<<<<<<< HEAD
  void _pinToStatusBar(int index) async {
    bool isPinned = notes[index]['statusBarPinned'] == 'true';
    int notificationId = int.parse(notes[index]['notificationId']!);

    if (isPinned) {
      await flutterLocalNotificationsPlugin.cancel(notificationId);
      setState(() {
        notes[index]['statusBarPinned'] = 'false';
      });
    } else {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id', // Use a unique channel ID
        'Your Channel Name',
        channelDescription: 'Your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: false, // Make the notification ongoing
        showWhen: false,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      
      await flutterLocalNotificationsPlugin.show(
        notificationId,
        notes[index]['title'],
        notes[index]['content'],
        platformChannelSpecifics,
      );

      setState(() {
        notes[index]['statusBarPinned'] = 'true';
      });
    }
  }

  void _deleteNote(int index) {
    _deleteNoteFromFirestore(notes[index]['id']!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note moved to trash'),
=======
  void _pinToStatusBar(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pinned to Status Bar')),
    );
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      _updateFilteredNotes();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note deleted'),
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
        duration: Duration(seconds: 2),
      ),
    );
  }

<<<<<<< HEAD
  void _restoreNoteFromTrash(int index) async {
    final noteId = trash[index]['id']!;
    await _firestore.collection('notes').doc(noteId).update({'deleted': false});
    _fetchDeletedNotes(); // Refresh the trash list
    _fetchNotesFromFirestore(); // Refresh active notes
  }

  void _permanentlyDeleteNoteFromTrash(int index) async {
    final noteId = trash[index]['id']!;
    await _firestore.collection('notes').doc(noteId).delete();
    _fetchDeletedNotes();
  }

  void _updateFilteredNotes() {
    setState(() {
      filteredNotes = notes;
    });
  }

  void _navigateToNoteById(String noteId) {
    final note = notes.firstWhere((note) => note['id'] == noteId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(
          note: note.map((key, value) => MapEntry(key, value.toString())),
          onEdit: () {
            // Handle edit action
          },
          onDelete: () {
            // Handle delete action
          },
          onPin: () {
            // Handle pin action
          },
          onPinToStatusBar: () {
            // Handle pin to status bar action
          },
        ),
      ),
    );
  }

  Future<void> _fetchDeletedNotes() async { // Updated to return Future<void>
    if (_deviceId == null) return; // Ensure the device ID is available

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('notes')
          .where('deviceId', isEqualTo: _deviceId) // Filter by device ID
          .where('deleted', isEqualTo: true) // Fetch only deleted notes
          .get();

      setState(() {
        trash = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'title': doc['title'] ?? '',
            'content': doc['content'] ?? '',
            'date': doc['date'] ?? 'No Date',
            'pinned': doc['pinned'] ?? 'false',
            'statusBarPinned': doc['statusBarPinned'] ?? 'false',
            'notificationId': doc['notificationId'] ?? '',
            'deviceId': doc['deviceId'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching deleted notes: $e');
    }
=======
  void _updateFilteredNotes() {
    final pinnedNotes = notes.where((note) => note['pinned'] == 'true').toList();
    final unpinnedNotes = notes.where((note) => note['pinned'] == 'false').toList();
    filteredNotes = pinnedNotes + unpinnedNotes;
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Notes'),
        ),
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

=======
    final List<Widget> _screens = [
      NotesScreenBody(
        notes: notes,
        filteredNotes: filteredNotes,
        onAddNote: _addNote,
        onUpdateNote: _updateNote,  // Added this line to update note
        onPinNote: _pinNote,
        onUnpinNote: _unpinNote,
        onDeleteNote: _deleteNote,
        onPinToStatusBar: _pinToStatusBar,
      ),
      CalendarScreen(),
      MoreScreen(),
    ];

    return Scaffold(
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
    );
  }
}

class NotesScreenBody extends StatelessWidget {
  final List<Map<String, String>> notes;
  final List<Map<String, String>> filteredNotes;
  final Function(String?, String) onAddNote;
  final Function(int, String?, String) onUpdateNote;  // Added this for updating notes
  final Function(int) onPinNote;
  final Function(int) onUnpinNote;
  final Function(int) onDeleteNote;
  final Function(int) onPinToStatusBar;

  NotesScreenBody({
    required this.notes,
    required this.filteredNotes,
    required this.onAddNote,
    required this.onUpdateNote,  // Added this for updating notes
    required this.onPinNote,
    required this.onUnpinNote,
    required this.onDeleteNote,
    required this.onPinToStatusBar,
  });

  @override
  Widget build(BuildContext context) {
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
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
<<<<<<< HEAD
                delegate: NotesSearchDelegate(
                  notes.map((note) => note.map((key, value) => MapEntry(key, value.toString()))).toList(),
                ),
=======
                delegate: NotesSearchDelegate(notes),  // Ensure NotesSearchDelegate is correctly defined and imported
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
              );
            },
          ),
        ],
      ),
<<<<<<< HEAD
      body: RefreshIndicator(
        onRefresh: _refreshNotes, // Call the refresh method
        child: filteredNotes.isEmpty
            ? Center(child: Text('No notes available'))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    if (pinnedNotes.isNotEmpty)
                      _buildSectionHeader('Pinned Notes'),
                    ...pinnedNotes.map((note) => _buildNoteTile(
                        context, 
                        note.map((key, value) => MapEntry(key.toString(), value.toString())), 
                        notes.indexOf(note)
                    )),
                    if (unpinnedNotes.isNotEmpty)
                      _buildSectionHeader('Other Notes'),
                    ...unpinnedNotes.map((note) => _buildNoteTile(
                        context, 
                        note.map((key, value) => MapEntry(key, value.toString())), // Convert values to String
                        notes.indexOf(note)
                    )),
                  ],
                ),
              ),
      ),
=======
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
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditNoteScreen()),
          );

          if (result != null && result is Map<String, String>) {
<<<<<<< HEAD
            _addNote(result['title'], result['content']!);
=======
            onAddNote(result['title'], result['content']!);
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
<<<<<<< HEAD
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notes',
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
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
=======
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
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
<<<<<<< HEAD
    // Ensure the index is valid before accessing the list
    if (index < 0 || index >= notes.length) {
      print('Invalid index: $index');
      return SizedBox.shrink(); // Return an empty widget if the index is invalid
    }

=======
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
    return NoteTile(
      title: note['title']!,
      date: note['date']!,
      content: note['content']!,
      isPinned: note['pinned'] == 'true',
<<<<<<< HEAD
      isStatusBarPinned: note['statusBarPinned'] == 'true',
      onPin: () => _pinNote(index),
      onUnpin: () => _unpinNote(index),
      onDelete: () => _deleteNote(index),
      onPinToStatusBar: () => _pinToStatusBar(index),
=======
      onPin: () => onPinNote(index),
      onUnpin: () => onUnpinNote(index),
      onDelete: () => onDeleteNote(index),
      onPinToStatusBar: () => onPinToStatusBar(index),
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
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
<<<<<<< HEAD
          _updateNoteInFirestore(note['id']!, result['title'], result['content']!);
=======
          onUpdateNote(index, result['title'], result['content']!);  // Updating the note at the given index
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
        }
      },
    );
  }
<<<<<<< HEAD

  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true; // Show loading indicator during refresh
    });
    await _fetchNotesFromFirestore(); // Fetch the latest notes
    _updateFilteredNotes(); // Update the filtered notes list
    setState(() {
      _isLoading = false; // Hide loading indicator after refresh
    });
  }
=======
>>>>>>> a1b95160833eedcaaa11b4eb71e252f762041fd6
}
