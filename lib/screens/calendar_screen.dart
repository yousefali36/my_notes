import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'edit_note_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _notes = {};

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                return _notes[day] ?? [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _showAddNoteDialog(selectedDay);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            SizedBox(height: 20),
            if (_selectedDay != null)
              Text(
                'Selected date: ${_selectedDay!.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            if (_selectedDay != null && _notes[_selectedDay] != null)
              Expanded(
                child: ListView.builder(
                  itemCount: _notes[_selectedDay]!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_notes[_selectedDay]![index]),
                      onLongPress: () => _showNoteOptionsDialog(_selectedDay!, index),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog(DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Note'),
        content: Text('Do you want to add a note for ${selectedDay.toLocal().toString().split(' ')[0]}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _addNoteForSelectedDay(selectedDay);
            },
            child: Text('Add Note'),
          ),
        ],
      ),
    );
  }

  Future<void> _addNoteForSelectedDay(DateTime selectedDay) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditNoteScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        if (_notes[selectedDay] == null) {
          _notes[selectedDay] = [];
        }
        _notes[selectedDay]!.add(result['content']!);
        _saveNotes();
      });
    }
  }

  void _showNoteOptionsDialog(DateTime selectedDay, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Note'),
            onTap: () {
              Navigator.pop(context);
              _editNoteForSelectedDay(selectedDay, index);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Note'),
            onTap: () {
              Navigator.pop(context);
              _deleteNoteForSelectedDay(selectedDay, index);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _editNoteForSelectedDay(DateTime selectedDay, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(
          initialContent: _notes[selectedDay]![index],
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        _notes[selectedDay]![index] = result['content']!;
        _saveNotes();
      });
    }
  }

  void _deleteNoteForSelectedDay(DateTime selectedDay, int index) {
    setState(() {
      _notes[selectedDay]!.removeAt(index);
      if (_notes[selectedDay]!.isEmpty) {
        _notes.remove(selectedDay);
      }
      _saveNotes();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('notes');
    if (notesString != null) {
      setState(() {
        _notes = (json.decode(notesString) as Map<String, dynamic>).map((key, value) {
          return MapEntry(DateTime.parse(key), List<String>.from(value));
        });
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String notesString = json.encode(_notes.map((key, value) {
      return MapEntry(key.toIso8601String(), value);
    }));
    await prefs.setString('notes', notesString);
  }
}
