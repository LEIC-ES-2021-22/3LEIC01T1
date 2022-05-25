import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remind_me_up/services/auth.dart';

class RecoverPassScreen extends StatefulWidget {
  final Function toggleScreen;

  const RecoverPassScreen(this.toggleScreen, {Key? key}) : super(key: key);

  @override
  State<RecoverPassScreen> createState() => _RecoverPassScreenState();
}

class _RecoverPassScreenState extends State<RecoverPassScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';

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
                  const Text('Recover Password',
                      style: TextStyle(fontSize: 32)),
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () => widget.toggleScreen(),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('Remember Password? Sign In'),
                    ),
                  ),
                  if (kDebugMode) ...[
                    const SizedBox(height: 50),
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
