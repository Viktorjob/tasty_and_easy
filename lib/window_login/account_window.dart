import 'package:tasty_and_easy/window_login/login_window.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Accountwindow extends StatefulWidget {
  const Accountwindow({super.key});

  @override
  State<Accountwindow> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<Accountwindow> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> signOut() async {
    final navigator = Navigator.of(context);

    await FirebaseAuth.instance.signOut();

    navigator.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ваш Email: ${user?.email}'),
            if (user == null)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Login'),
              )
            else
              TextButton(
                onPressed: () => signOut(),
                child: const Text('Leave'),
              ),
          ],
        ),
      ),
    );
  }
}


