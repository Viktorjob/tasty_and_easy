
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasty_and_easy/window_login/login_window.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasty_and_easy/window_menu/home_window.dart';

class Accountwindow extends StatefulWidget {
  const Accountwindow({super.key});

  @override
  State<Accountwindow> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<Accountwindow> {
  final user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;


  Future<void> signOut() async {
    final navigator = Navigator.of(context);

    await FirebaseAuth.instance.signOut();

    navigator.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B0E12),
        title: (user == null)
            ? Text("Profil", style: TextStyle(color: Colors.white, fontSize: 25,))
            : Text("Your Profil", style: TextStyle(color: Colors.white, fontSize: 25,)),
      ),
      backgroundColor: Color(0xFF0B0E12),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Проверяем, аутентифицирован ли пользователь
            if (user != null)
              FutureBuilder(
                future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      String userName = snapshot.data!.get('name');
                      print('User Name: $userName');


                      return Text('Привет, $userName!', style: TextStyle(color: Colors.white));
                    } else {
                      return Text('Привет!', style: TextStyle(color: Colors.white));
                    }
                  }
                },
              ),
            Text('Ваш Email: ${user?.email}', style: TextStyle(color: Colors.white, fontSize: 12,)),
            if (user == null)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ), // Отступы кнопки
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            else
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ), // Отступы кнопки
                ),
                onPressed: () => signOut(),
                child: const Text(
                  'Leave',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

}


