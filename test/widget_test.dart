import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Add a const constructor
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Demo'),
        ),
        body: Center(
          child: Text('0'), // Replace this with your widget tree
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Increment logic
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
