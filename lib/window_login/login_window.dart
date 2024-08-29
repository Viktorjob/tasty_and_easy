import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasty_and_easy/services_firebase/file_snack.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  TextEditingController nameTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();

    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login() async {
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackBarService.showSnackBar(
          context,
          'Неправильный email или пароль. Повторите попытку',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
        return;
      }
    }

    navigator.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B0E12), // Цвет AppBar
        title: const Text('Войти', style: TextStyle(color: Colors.white)), // Цвет текста AppBar
      ),
      backgroundColor: Color(0xFF0B0E12), // Цвет фона Scaffold
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: emailTextInputController,
                validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Введите правильный Email'
                    : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber), // Цвет линии
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber), // Цвет линии при фокусе
                  ),
                  hintText: 'Введите Email',
                  hintStyle: TextStyle(color: Colors.white), // Цвет подсказки
                ),
                style: TextStyle(color: Colors.white), // Цвет текста
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                controller: passwordTextInputController,
                obscureText: isHiddenPassword,
                validator: (value) => value != null && value.length < 6
                    ? 'Минимум 6 символов'
                    : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber), // Цвет линии
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber), // Цвет линии при фокусе
                  ),
                  border: const OutlineInputBorder(),
                  hintText: 'Введите пароль',
                  hintStyle: TextStyle(color: Colors.white), // Цвет подсказки
                  suffix: InkWell(
                    onTap: togglePasswordView,
                    child: Icon(
                      isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white, // Цвет иконки
                    ),
                  ),
                ),
                style: TextStyle(color: Colors.white), // Цвет текста
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: login,
                child: const Center(child: Text('Войти')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Цвет кнопки
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _signInWithGoogle(),

                child: const Center(child: Text('Google')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Цвет кнопки
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/signup'),
                child: const Text(
                  'Регистрация',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white, // Цвет текста
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/reset_password'),
                child: const Text(
                  'Сбросить пароль',
                  style: TextStyle(color: Colors.white), // Цвет текста
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _signInWithGoogle()async{

    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    try {

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if(googleSignInAccount != null ){
        final GoogleSignInAuthentication googleSignInAuthentication = await
        googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

       await _firebaseAuth.signInWithCredential(credential);
        Navigator.pushNamed(context, "/home");
      }
    }catch(e) {
      print('Error');
    }

  }

}
