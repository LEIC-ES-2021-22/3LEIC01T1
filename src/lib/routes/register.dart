import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remind_me_up/services/auth.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleScreen;

  const RegisterScreen(this.toggleScreen, {Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Column(
                children: [
                  const Text('Sign Up', style: TextStyle(fontSize: 32)),
                  Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'Email',
                              contentPadding: EdgeInsets.zero,
                            ),
                            validator: (v) =>
                                v == null || v.length < 5 || !v.contains('@')
                                    ? 'Invalid email'
                                    : null,
                            onChanged: (v) => setState(() => _email = v.trim()),
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'Password',
                              contentPadding: EdgeInsets.zero,
                            ),
                            validator: (v) => v == null || v.runes.length < 6
                                ? 'Minimum 6 characters'
                                : null,
                            obscureText: true,
                            onChanged: (v) => setState(() => _password = v),
                            autofillHints: const [AutofillHints.newPassword],
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'Confirm Password',
                              contentPadding: EdgeInsets.zero,
                            ),
                            validator: (v) => v == null || v != _password
                                ? 'Passwords must match'
                                : null,
                            obscureText: true,
                            autofillHints: const [AutofillHints.newPassword],
                            keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),
                        _loading
                            ? const SpinKitRing(
                                color: Colors.deepPurple,
                                lineWidth: 5,
                              )
                            : OutlinedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _loading = true);
                                    await _auth.registerEmailPassword(
                                      _email,
                                      _password,
                                    );
                                  }

                                    if (mounted) {
                                      setState(() => _loading = false);
                                    }
                                  },
                                  child: const Text(
                                    'SIGN UP',
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
                      child: Text('Already have an account? Sign In'),
                    ),
                  ),
                  if (kDebugMode) ...[
                    const SizedBox(height: 50),
                    Text('$_email | $_password')
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
