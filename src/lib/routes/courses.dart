import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remind_me_up/models/course.dart';
import 'package:remind_me_up/routes/home.dart';
import 'package:remind_me_up/services/database.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Course>>.value(
      value: DatabaseService().courses,
      initialData: const [],
      builder: (context, child) {
        final courses = context.watch<List<Course>>();
        courses.sort((a, b) => a.name.compareTo(b.name));

        return DefaultScaffold(
          child: Column(
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
              ...courses.map((e) => ListTile(
                    title: Text(e.name),
                    subtitle: Text(e.shortName),
                    onTap: () {},
                    trailing:
                        Checkbox(value: false, onChanged: (bool? value) {}),
                  )),
            ],
          ),
        );
      },
    );
  }
}
