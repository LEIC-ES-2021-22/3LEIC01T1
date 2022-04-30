import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remind_me_up/event_card.dart';
import 'package:remind_me_up/models/event.dart';
import 'package:remind_me_up/routes/auth_wrapper.dart';
import 'package:remind_me_up/routes/courses.dart';
import 'package:remind_me_up/services/auth.dart';
import 'package:remind_me_up/services/database.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Text(
                    'ALL EVENTS',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<QueryDocumentSnapshot<Event>>>(
              future: DatabaseService().userEvents,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }

                print(snapshot.data);

                return Column(
                  children: snapshot.data!
                      .map((e) => EventCard(event: e.data()))
                      .toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold(
      {Key? key, required this.child, this.floatingActionButton})
      : super(key: key);

  final Widget? child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DefaultDrawer(),
      body: CustomScrollView(
        slivers: [
          DefaultAppBar(),
          SliverToBoxAdapter(
            child: child,
          )
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 100,
            child: DrawerHeader(
              child: Text(
                'RemindMe UP',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuthWrapper()),
            ),
          ),
          ListTile(
            title: const Text('Courses'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CoursesScreen()),
            ),
          )
        ],
      ),
    );
  }
}

class DefaultAppBar extends StatelessWidget {
  DefaultAppBar({
    Key? key,
  }) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      actions: [
        ElevatedButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  titleTextStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  title: Text(
                      _auth.user?.displayName ?? _auth.user?.email ?? 'User'),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        _auth.logout();

                        // push AuthWrapper to go back to login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthWrapper()),
                        );
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                );
              }),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(2),
          ),
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/okayeg.png'),
          ),
        ),
        const SizedBox(width: 15)
      ],
    );
  }
}
