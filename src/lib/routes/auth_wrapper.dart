import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remind_me_up/routes/authenticate.dart';
import 'package:remind_me_up/routes/home.dart';
import 'package:remind_me_up/services/pushNotification.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    PushNotification().init();
    return user != null ? const Home() : const Authenticate();
  }
}
