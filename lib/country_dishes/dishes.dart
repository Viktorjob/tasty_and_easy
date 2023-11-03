import 'package:flutter/material.dart';

class country_dish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Вернуть AppBar
        title: Text("Hello"),
        backgroundColor: Colors.lightGreen,
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
