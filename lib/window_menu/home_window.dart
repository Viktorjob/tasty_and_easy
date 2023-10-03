import 'package:tasty_and_easy/window_menu/FirstPage.dart';
import 'package:tasty_and_easy/window_menu/account_window.dart';
import 'package:tasty_and_easy/window_menu/like_window.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [BottomNavigationBar].



class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:BottomNavigationBarExample(),

    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    FirstPage(),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'like',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}