import 'package:flutter/material.dart';

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
        // appBarTheme: const AppBarTheme(
        //     backgroundColor: Colors.transparent, elevation: 0)
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(title: appTitle),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Clicked: $_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
