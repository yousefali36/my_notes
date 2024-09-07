// lib/screens/more_screen.dart
import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Options'),
      ),
      body: Center(
        child: Text('This is the More Screen. Add more options here.'),
      ),
    );
  }
}
