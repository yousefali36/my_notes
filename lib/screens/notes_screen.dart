import 'package:flutter/material.dart';
import 'package:my_notes/screens/more_screen.dart';
import 'edit_note_screen.dart';
import 'calendar_screen.dart';
import '../widgets/note_tile.dart';
import 'notes_search_delegate.dart';  // Ensure this import is correct

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  int _selectedIndex = 0;
  List<Map<String, String>> notes = [];
  List<Map<String, String>> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredNotes();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        'title': title ?? '',
        'content': content,
        'date': DateTime.now().toString().substring(0, 10),
        'pinned': notes[index]['pinned'] ?? 'false',
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
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _updateFilteredNotes() {
    final pinnedNotes = notes.where((note) => note['pinned'] == 'true').toList();
    final unpinnedNotes = notes.where((note) => note['pinned'] == 'false').toList();
    filteredNotes = pinnedNotes + unpinnedNotes;
  }

  @override
  Widget build(BuildContext context) {
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
                delegate: NotesSearchDelegate(notes),  // Ensure NotesSearchDelegate is correctly defined and imported
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
          onUpdateNote(index, result['title'], result['content']!);  // Updating the note at the given index
        }
      },
    );
  }
}
