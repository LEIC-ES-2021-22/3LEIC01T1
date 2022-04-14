import 'package:flutter/material.dart';
import 'package:remind_me_up/event.dart';

void main() {
  runApp(const RemindMeUP());
}

class RemindMeUP extends StatelessWidget {
  const RemindMeUP({Key? key}) : super(key: key);
  static const appTitle = 'RemindMeUP';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1b1a2d),
        primaryColor: Colors.deepPurple,
        cardColor: const Color(0xff261e3e),
        // appBarTheme: const AppBarTheme(
        //     backgroundColor: Colors.transparent, elevation: 0)
      ),
      themeMode: ThemeMode.system,
      home: HomePage(title: appTitle),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  final List<Event> events = [
    Event(
      name: 'Invited talk by Prof. Pimenta Monteiro',
      deadline: DateTime.now().add(const Duration(hours: 1)),
      course: 'ESOF',
      duration: const Duration(hours: 2),
      teacher: 'Ademar Aguiar',
    ),
    Event(
        name: 'Gib eg',
        deadline: DateTime.now().add(const Duration(days: 1)),
        course: 'Okayeg'),
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
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Color(0xFF1b1a2d),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple.shade700,
            floating: true,
            actions: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                ),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/okayeg.png'),
                ),
              ),
              const SizedBox(width: 10)
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                        child: Text(
                          'ALL EVENTS',
                          style: TextStyle(
                            letterSpacing: 3,
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
