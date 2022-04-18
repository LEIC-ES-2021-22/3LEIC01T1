import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future registerEmailPassword(String email, String password) async {
    try {
      return (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return null;
    }
  }

  Future logout() async {
    return await _auth.signOut();
  }

  Future loginEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return e;
    }
  }
}
