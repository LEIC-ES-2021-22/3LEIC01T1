import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remind_me_up/event_card.dart';
import 'package:remind_me_up/models/course.dart';
import 'package:remind_me_up/models/event.dart';
import 'package:remind_me_up/routes/auth_wrapper.dart';
import 'package:remind_me_up/routes/create_event.dart';
import 'package:remind_me_up/routes/courses.dart';
import 'package:remind_me_up/services/auth.dart';
import 'package:remind_me_up/services/database.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  int eventCategory;
  Home({Key? key, this.eventCategory = 0}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _title = 'ALL EVENTS';

  Text getTitle() {
    switch (widget.eventCategory) {
      case 0:
        return const Text(
          'ALL EVENTS',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        );

      case 1: // today
        return const Text(
          'TODAY EVENTS',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        );

      case 2: // tomorrow
        return const Text(
          'TOMORROW EVENTS',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        );

      case 3: // in aweek
        return const Text(
          'EVENTS IN A WEEK',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        );

      case 4: // in a month
        return const Text(
          'EVENTS IN A MONTH',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        );

      default:
        return const Text(
          'ALL EVENTS',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

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
                    'ALL EVENTS', // TODO: CHANGE THIS ACCORDINGLY
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: Future.wait([
                DatabaseService().userEvents,
                DatabaseService().userCoursesM
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitRing(
                    color: Colors.deepPurple,
                    lineWidth: 5,
                  );
                }

                // print(snapshot.data);

                final List<QueryDocumentSnapshot<Course>> courses =
                    snapshot.data![1];
                List<QueryDocumentSnapshot<Event>> events = snapshot.data![0];
                if (events.isNotEmpty) {
                  switch (widget.eventCategory) {
                    case 0:
                      break;
                    case 1: // today
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      List<QueryDocumentSnapshot<Event>> newEvents =
                          <QueryDocumentSnapshot<Event>>[];
                      for (var event in events) {
                        DateTime deadline = DateTime.fromMillisecondsSinceEpoch(
                            event.get('deadline').seconds * 1000);
                        final aDate = DateTime(
                            deadline.year, deadline.month, deadline.day);
                        if (aDate == today) {
                          newEvents.add(event);
                        }
                      }
                      events = newEvents;
                      break;
                    case 2: // tomorrow
                      final now = DateTime.now();
                      final tomorrow =
                          DateTime(now.year, now.month, now.day + 1);
                      List<QueryDocumentSnapshot<Event>> newEvents =
                          <QueryDocumentSnapshot<Event>>[];
                      for (var event in events) {
                        DateTime deadline = DateTime.fromMillisecondsSinceEpoch(
                            event.get('deadline').seconds * 1000);
                        final aDate = DateTime(
                            deadline.year, deadline.month, deadline.day);
                        if (aDate == tomorrow) {
                          newEvents.add(event);
                        }
                      }
                      events = newEvents;
                      break;
                    case 3: // in aweek
                      List<QueryDocumentSnapshot<Event>> newEvents =
                          <QueryDocumentSnapshot<Event>>[];
                      for (var event in events) {
                        DateTime deadline = DateTime.fromMillisecondsSinceEpoch(
                            event.get('deadline').seconds * 1000);
                        final aDate = DateTime(
                            deadline.year, deadline.month, deadline.day);
                        int daysDiff = daysBetween(DateTime.now(), aDate);
                        if (daysDiff < 7 && daysDiff >= 0) {
                          newEvents.add(event);
                        }
                      }
                      events = newEvents;
                      break;
                    case 4: // in a month
                      List<QueryDocumentSnapshot<Event>> newEvents =
                          <QueryDocumentSnapshot<Event>>[];
                      for (var event in events) {
                        DateTime deadline = DateTime.fromMillisecondsSinceEpoch(
                            event.get('deadline').seconds * 1000);
                        final aDate = DateTime(
                            deadline.year, deadline.month, deadline.day);
                        int daysDiff = daysBetween(DateTime.now(), aDate);
                        if (daysDiff < 30 && daysDiff >= 0) {
                          newEvents.add(event);
                        }
                      }
                      events = newEvents;
                      break;
                    default:
                  }
                }

                return events.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        itemCount: events.length,
                        itemBuilder: (context, index) => EventCard(
                          course: courses
                              .firstWhere((element) =>
                                  element.id == events[index].data().courseId)
                              .data(),
                          event: events[index].data(),
                          eventid: events[index].id,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("You don't have any events"),
                            Text("Try adding courses in the Courses tab"),
                          ],
                        ),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}

class DefaultScaffold extends StatefulWidget {
  const DefaultScaffold(
      {Key? key, required this.child, this.floatingActionButton})
      : super(key: key);

  final Widget? child;
  final Widget? floatingActionButton;

  @override
  State<DefaultScaffold> createState() => _DefaultScaffoldState();
}

class _DefaultScaffoldState extends State<DefaultScaffold> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    requestPermission();
    loadFCM();
    listenFCM();
    getToken();
    tz.initializeTimeZones();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) => print(value));
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DefaultDrawer(),
      body: CustomScrollView(
        slivers: [
          DefaultAppBar(),
          SliverToBoxAdapter(
            child: widget.child,
          )
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}

class DefaultDrawer extends StatefulWidget {
  const DefaultDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<DefaultDrawer> createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends State<DefaultDrawer> {
  int _role = 0;
  @override
  void initState() {
    super.initState();
    getAsyncData();
  }

  void getAsyncData() async {
    final role = await DatabaseService().hasPermission();

    setState(() {
      _role = role;
    });
  }

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
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.inbox_outlined),
            title: const Text('All Events'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuthWrapper()),
            ),
          ),
          Row(children: <Widget>[
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 70.0, right: 0),
                  child: const Divider(
                    color: Color.fromARGB(255, 149, 148, 148),
                    height: 40,
                  )),
            ),
          ]),
          ListTile(
            leading: const Icon(Icons.calendar_today_sharp),
            title: const Text('Today'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(eventCategory: 1),
                )),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text('Tomorrow'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(eventCategory: 2),
                )),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('In A Week'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(eventCategory: 3),
                )),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('In A Month'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(eventCategory: 4),
                )),
          ),
          Row(children: <Widget>[
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 70.0, right: 0),
                  child: const Divider(
                    color: Color.fromARGB(255, 149, 148, 148),
                    height: 40,
                  )),
            ),
          ]),
          ListTile(
            leading: const Icon(Icons.bookmark_add),
            title: const Text('Courses'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CoursesScreen(),
                )),
          ),
          if (_role == 1)
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text("Create Event"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateEvent()),
              ),
            ),
            Row(children: <Widget>[
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 70.0, right: 0),
                  child: const Divider(
                    color: Color.fromARGB(255, 149, 148, 148),
                    height: 40,
                  )),
            ),
          ]),
                      ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CoursesScreen()),
              ),
            ),
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
        const SizedBox(width: 16)
      ],
    );
  }
}
