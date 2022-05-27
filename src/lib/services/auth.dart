import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get userStream {
    return _auth.authStateChanges();
  }

  User? get user {
    return _auth.currentUser;
  }

  Future<String?> registerEmailPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      }

      if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return 'An unknown error occurred';
    }

    return null;
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
