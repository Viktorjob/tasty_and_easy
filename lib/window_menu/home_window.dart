import 'package:flutter/material.dart';

import 'package:tasty_and_easy/window_menu/FirstPage.dart';
import 'package:tasty_and_easy/window_menu/account_window.dart';
import 'package:tasty_and_easy/window_menu/like_window.dart';
import 'package:tasty_and_easy/window_menu/list.dart';

class home extends StatelessWidget {
  const home({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavigationBarExample(),

    );
  }
}
// ...

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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3, // Высота полоски
            color: Colors.amber, // Цвет полоски
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF0B0E12), // Фон для нижней навигационной панели
              border: Border(
                top: BorderSide(color: Color(0xFF0B0E12), width: 8.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildNavigationBarItem(Icons.home, 0),
                buildNavigationBarItem(Icons.list, 1),
                buildNavigationBarItem(Icons.bookmark_border, 2),
                buildNavigationBarItem(Icons.account_circle, 3),
              ],
            ),
            padding: EdgeInsets.only(bottom: 8.0),
          ),
        ],
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
          color: isSelected ?   Colors.amber : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white,
        ),
      ),
    );
  }
}

