import 'package:tasty_and_easy/window_login/verify_email_window.dart';
import 'package:tasty_and_easy/window_menu/home_window.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class FirebaseStream extends StatelessWidget {
  const FirebaseStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
              body: Center(child: Text('Error!')));
        } else if (snapshot.hasData) {
          if (!snapshot.data!.emailVerified) {
            return const VerifyEmailScreen();
          }
          return const home();
        } else {
          return const home();
        }
      },
    );
  }
}
