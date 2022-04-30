import 'package:flutter/material.dart';
import 'package:remind_me_up/routes/login.dart';
import 'package:remind_me_up/routes/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // TODO use something better with support for more screens
  bool showRegister = false;

  void toggleScreen() => setState(() => showRegister = !showRegister);

  @override
  Widget build(BuildContext context) {
    return showRegister ? RegisterScreen(toggleScreen) : LoginScreen(toggleScreen);
  }
}
