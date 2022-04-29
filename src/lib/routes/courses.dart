import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remind_me_up/models/course.dart';
import 'package:remind_me_up/routes/home.dart';
import 'package:remind_me_up/services/database.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Course> _courses = [];
  Set<String> _selected = {};
  Set<String> _remote = {};

  bool _loading = true;

  void getData() async {
    await Future.wait<void>([
      DatabaseService().courses.then((val) => _courses = val),
      DatabaseService().userCourses.then((val) => _remote = val),
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

    var newSet = await DatabaseService().userCourses;

    setState(() {
      _remote = newSet;
      _selected = Set.from(newSet);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Courses updated"), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("_courses: $_courses");
      print("_selected: $_selected");
      print("_remote: $_remote");
    }

    return DefaultScaffold(
      floatingActionButton: _loading || setEquals(_remote, _selected)
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
                    return CheckboxListTile(
                      title: Text(course.name),
                      subtitle: Text(course.shortName),
                      value: _selected.contains(course.uid),
                      onChanged: (bool? value) => setState(() => value == true
                          ? _selected.add(course.uid)
                          : _selected.remove(course.uid)),
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
