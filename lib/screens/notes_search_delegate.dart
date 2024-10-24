import 'package:flutter/material.dart';
import 'note_detail_screen.dart'; // Ensure this file exists and is correctly implemented

class NotesSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> notes;

  NotesSearchDelegate(this.notes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredNotes = notes
        .where((note) => note['content']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final note = filteredNotes[index];
        return ListTile(
          title: _highlightSearchTerms(context, note['title']!),
          subtitle: _highlightSearchTerms(context, note['content']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailScreen(
                  note: note,
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
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredNotes = notes
        .where((note) => note['content']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final note = filteredNotes[index];
        return ListTile(
          title: _highlightSearchTerms(context, note['title']!),
          subtitle: _highlightSearchTerms(context, note['content']!),
          onTap: () {
            query = note['content']!;
            showResults(context);
          },
        );
      },
    );
  }

  Widget _highlightSearchTerms(BuildContext context, String text) {
    final List<TextSpan> spans = [];
    final List<String> parts = text.split(RegExp('(${query})', caseSensitive: false));
    for (final part in parts) {
      if (part.toLowerCase() == query.toLowerCase()) {
        spans.add(TextSpan(
          text: part,
          style: TextStyle(backgroundColor: Colors.yellow),
        ));
      } else {
        spans.add(TextSpan(text: part));
      }
    }
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: spans,
      ),
    );
  }
}
