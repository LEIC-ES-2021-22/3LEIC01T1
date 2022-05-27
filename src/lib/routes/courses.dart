import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remind_me_up/models/course.dart';
import 'package:remind_me_up/routes/home.dart';
import 'package:remind_me_up/services/database.dart';

import '../services/pushNotification.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);
  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<QueryDocumentSnapshot<Course>> _courses = [];
  List<String> _remote = [];
  Set<String> _selected = {};

  bool _loading = true;

  void getData() async {
    await Future.wait<void>([
      DatabaseService().courses.then((val) => _courses = val.docs),
      DatabaseService()
          .userCoursesM
          .then((val) => _remote = val.map((e) => e.id).toList()),
    ]);

    setState(() {
      _selected = Set.from(_remote);
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void updateCourses() async {
    DatabaseService().saveUserCourses(_selected);

    final res =
        (await DatabaseService().userCoursesM).map((c) => c.id).toList();
    setState(() {
      _remote = res;
      _selected = Set.from(res);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Courses updated"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      //print("_courses: $_courses");
      print("_selected: $_selected");
      print("_remote: $_remote");
    }
    PushNotification().init();

    return DefaultScaffold(
      floatingActionButton: _loading || setEquals(_remote.toSet(), _selected)
          ? null
          : FloatingActionButton(
              onPressed: updateCourses,
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
                  itemCount: _courses.length,
                  itemBuilder: (context, index) {
                    final course = _courses[index];
                    return SwitchListTile(
                      title: Text(course.data().name),
                      subtitle: Text(course.data().shortName),
                      value: _selected.contains(course.id),
                      onChanged: (bool? value) => setState(() => value == true
                          ? _selected.add(course.id)
                          : _selected.remove(course.id)),
                    );
                  },
                  primary: false,
                  shrinkWrap: true,
                ),
              ],
            ),
    );
  }
}
