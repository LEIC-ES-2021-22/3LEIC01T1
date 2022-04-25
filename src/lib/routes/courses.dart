import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:remind_me_up/models/course.dart';
import 'package:remind_me_up/routes/home.dart';
import 'package:remind_me_up/services/auth.dart';
import 'package:remind_me_up/services/database.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return MultiProvider(
      providers: [
        StreamProvider<List<Course>>(
          create: (context) => DatabaseService(uid: user!.uid).courses,
          initialData: const [],
        ),
        // StreamProvider<UserData?>(
        //   create: (context) => DatabaseService(uid: user!.uid).userData,
        //   initialData: null,
        // ),
      ],
      child: const CoursesList(),
    );
  }
}

class CoursesList extends StatefulWidget {
  const CoursesList({Key? key}) : super(key: key);

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  bool _loading = true;
  Set<String> _selected = {};
  Set<String> _remote = {};

  void getUserData() async {
    var data = await FirebaseFirestore.instance
        .collection('user_data')
        .doc(AuthService().user?.uid)
        .get();

    setState(() {
      var set = (data.get('courses') as List).map((id) => id as String).toSet();
      _selected = Set.from(set);
      _remote = set;

      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    print("selected: $_selected");
    print("_remote: $_remote");

    final courses = Provider.of<List<Course>>(context);

    return DefaultScaffold(
      floatingActionButton: _loading || setEquals(_remote, _selected)
          ? null
          : FloatingActionButton(
              onPressed: () => {
                // TODO: Update firestore
              },
              child: const Icon(Icons.save),
            ),
      child: _loading
          ? const SpinKitRing(
              color: Colors.deepPurple,
              lineWidth: 5,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: Text(
                    'AVAILABLE COURSES',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.separated(
                  padding: const EdgeInsets.only(bottom: 75),
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) => CheckboxListTile(
                    title: Text(courses[index].name),
                    subtitle: Text(courses[index].shortName),
                    value: _selected.contains(courses[index].uid),
// userdata?.courses.contains(courses[index].uid) ?? false,
                    onChanged: (bool? value) => setState(() => value == true
                        ? _selected.add(courses[index].uid)
                        : _selected.remove(courses[index].uid)),
                  ),
                  primary: false,
                  shrinkWrap: true,
                ),
              ],
            ),
    );
  }
}
