import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remind_me_up/firebase_options.dart';
import 'package:remind_me_up/routes/auth_wrapper.dart';
import 'package:remind_me_up/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const RemindMeUP());
}

class RemindMeUP extends StatelessWidget {
  const RemindMeUP({Key? key}) : super(key: key);
  static const appTitle = 'RemindMeUP';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().userStream,
      initialData: null,
      child: MaterialApp(
        title: appTitle,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          toggleableActiveColor: Colors.deepPurple,
          scaffoldBackgroundColor: const Color(0xFF1b1a2d),
          cardColor: const Color(0xff23223b),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.white10,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1b1a2d),
            elevation: 0,
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Color(0xFF1b1a2d),
          ),
        ),
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
      ),
    );
  }
}
