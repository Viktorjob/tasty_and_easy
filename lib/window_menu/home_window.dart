import 'package:flutter/material.dart';
import 'package:tasty_and_easy/window_login/FirstPage.dart';
import 'package:tasty_and_easy/window_login/account_window.dart';
import 'package:tasty_and_easy/window_menu/like_window.dart';
import 'package:tasty_and_easy/window_menu/list.dart';

class home extends StatelessWidget {
  const home({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({Key? key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    FirstPage(),
    RecipeList(),
    LikeWindow(),
    Accountwindow(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFFA4A4A4), // Фон для нижней навигационной панели
          border: Border(
            top: BorderSide(color: Color(0xFFA4A4A4), width: 8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            buildNavigationBarItem(Icons.home, 0),
            buildNavigationBarItem(Icons.list, 1),
            buildNavigationBarItem(Icons.favorite, 2),
            buildNavigationBarItem(Icons.account_circle, 3),
          ],
        ),
        padding: EdgeInsets.only(bottom: 8.0),
      ),
    );
  }

  Widget buildNavigationBarItem(IconData icon, int index) {
    final isSelected = index == _selectedIndex;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.lightGreen : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
