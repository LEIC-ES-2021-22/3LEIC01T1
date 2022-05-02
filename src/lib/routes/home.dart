import 'package:flutter/material.dart';
import 'package:remind_me_up/event_card.dart';
import 'package:remind_me_up/models/event.dart';
import 'package:remind_me_up/routes/create_event.dart';
import 'package:remind_me_up/routes/courses.dart';
import 'package:remind_me_up/services/auth.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final List<Event> events = [
    Event(
      name: 'Invited talk by Prof. Pimenta Monteiro',
      deadline: DateTime.now().add(const Duration(minutes: 22)),
      course: 'ESOF',
      duration: const Duration(hours: 2),
      teacher: 'Ademar Aguiar',
    ),
    Event(
      name: 'Teste 1',
      course: 'LCOM',
      duration: const Duration(hours: 2),
      deadline: DateTime.now().add(const Duration(days: 1)),
    ),
    Event(
        name: 'Gib eg3',
        deadline: DateTime.now().add(const Duration(days: 3)),
        course: 'Okayeg2'),
    Event(
        name: 'Gib eg4',
        deadline: DateTime.now().add(const Duration(days: 4)),
        course: 'Okayeg3'),
    Event(
        name: 'Gib eg5',
        deadline: DateTime.now().add(const Duration(days: 5)),
        course: 'Okayeg4'),
    Event(
        name: 'Gib eg6',
        deadline: DateTime.now().add(const Duration(days: 5)),
        course: 'Okayeg6'),
    Event(
        name: 'Gib eg6',
        deadline: DateTime.now().add(const Duration(days: 5)),
        course: 'Okayeg6'),
  ];

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
            ...events.map((e) => EventCard(event: e)).toList(),
          ],
        ),
      ),
    );
  }
}

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({Key? key, required this.child}) : super(key: key);

  final Widget? child;

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
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home())),
          ),
          ListTile(
            title: const Text('Courses'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CoursesScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text("Create Event"),
            onTap: (){
              print("clicked on create event");
              Navigator.push(
                  context, MaterialPageRoute(builder: (context)=> CreateEvent())
              );

            },
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
                        Navigator.pop(context);
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
