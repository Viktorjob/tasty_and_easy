import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikeWindow extends StatefulWidget {
  const LikeWindow({Key? key}) : super(key: key);

  @override
  _LikeWindowState createState() => _LikeWindowState();
}

class _LikeWindowState extends State<LikeWindow> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: (user == null)
             ? const Text("Контент для НЕ зарегистрированных в системе")
        : const Text('Контент для ЗАРЕГИСТРИРОВАННЫХ в системе'),

    ),
      ),
    );
  }
}
