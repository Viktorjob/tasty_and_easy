import 'package:tasty_and_easy/window_menu/FirstPage.dart';
import 'package:tasty_and_easy/window_menu/account_window.dart';
import 'package:tasty_and_easy/window_menu/home_window.dart';
import 'package:tasty_and_easy/window_menu/like_window.dart';


import 'package:tasty_and_easy/window_menu/login_window.dart';
import 'package:tasty_and_easy/window_menu/reset_password_window.dart';
import 'package:tasty_and_easy/window_menu/singup_window.dart';
import 'package:tasty_and_easy/window_menu/verify_email_window.dart';
import 'package:tasty_and_easy/services_firebase/firebase_window.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const home(),
        '/First': (context) => const FirstPage(),
        '/like': (context) => const LikeWindow(),
        '/account': (context) => const Accountwindow(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
      },
      initialRoute: '/',
    );
  }
}
