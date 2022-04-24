import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remind_me_up/models/course.dart';

class DatabaseService {
  final CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');

  List<Course> _coursesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((d) => Course(
            name: d.get('name') ?? 'Course Name',
            shortName: d.get('shortName')))
        .toList();
  }

  Stream<List<Course>> get courses {
    return courseCollection
        .snapshots()
        .map(_coursesFromSnapshot);
  }

// final CollectionReference eventCollection = FirebaseFirestore.instance.collection('events');
}
