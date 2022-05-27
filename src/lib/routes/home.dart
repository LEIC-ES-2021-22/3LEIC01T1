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
                final List<QueryDocumentSnapshot<Event>> events =
                    snapshot.data![0];

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

  void getToken() async{
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

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User Granted permission");
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted provisional permission");

    }
    else{
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
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   Navigator.pushNamed(
    //     context,
    //     '/message',
    //     arguments: MessageArguments(message, true),
    //   );
    // });
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

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CoursesScreen(),
              )
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text("Create Event"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateEvent()),
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
        const SizedBox(width: 16)
      ],
    );
  }
}
