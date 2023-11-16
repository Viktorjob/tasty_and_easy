import 'package:flutter/material.dart';

class Filters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Вернуть AppBar
        title: Text("Filters"),
        backgroundColor: Color(0xFFECAD16FF),
      ),
      body: Center(
        child: Text(
          'Hello',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
