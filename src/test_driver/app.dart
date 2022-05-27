import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';

import '../lib/main.dart';

void main() async {
  enableFlutterDriverExtension();

  await Firebase.initializeApp();

  await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);

  runApp(const RemindMeUP());
}
