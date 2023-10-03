import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Главная страница'),
             ),
      body: SafeArea(
        child: Center(
          child: (user == null)
              ? const Text("Контент для НЕ зарегистрированных в системе")
              : const Text('Контент для ЗАРЕГИСТРИРОВАННЫХ в системе'),

        ),
      ),
    );
  }
}


