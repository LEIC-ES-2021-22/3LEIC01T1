import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remind_me_up/services/auth.dart';
import 'package:remind_me_up/services/database.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleScreen;

  const LoginScreen(this.toggleScreen, {Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 32),
                  ),
                  Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          TextFormField(
                            key: const ValueKey('email'),
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'Email',
                              contentPadding: EdgeInsets.zero,
                            ),
                            validator: (v) => v == null || v.length < 5 || !v.contains('@')
                                ? 'Invalid email'
                                : null,
                            onChanged: (v) => setState(() => _email = v.trim()),
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            key: const ValueKey('password'),
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'Password',
                              contentPadding: EdgeInsets.zero,
                            ),
                            validator: (v) =>
                                v == null || v.runes.length < 6 ? 'Minimum 6 characters' : null,
                            obscureText: true,
                            onChanged: (v) => setState(() => _password = v),
                            autofillHints: const [AutofillHints.password],
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 20),
                          _loading
                              ? const SpinKitRing(
                                  color: Colors.deepPurple,
                                  lineWidth: 5,
                                )
                              : OutlinedButton(
                                  key: const ValueKey('login'),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _loading = true);
                                      FirebaseAuthException? res =
                                          await _auth.loginEmailPassword(_email, _password);
                                      if (res != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(res.message ?? 'Something went wrong'),
                                          ),
                                        );
                                      }
                                    }
                                    else{
                                      String ?token;
                                      await FirebaseMessaging.instance.getToken().then((value) {
                                        token = value;
                                      });
                                      DatabaseService().saveUserNotificationToken(token);
                                    }
                                    if (mounted) {
                                      setState(() => _loading = false);
                                    }
                                  },
                                  child: const Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () => widget.toggleScreen(),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text("Don't have an account? Sign Up"),
                    ),
                  ),
                  if (kDebugMode) ...[const SizedBox(height: 50), Text('$_email | $_password')]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
