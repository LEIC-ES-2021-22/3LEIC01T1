import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remind_me_up/models/course.dart';
import 'package:remind_me_up/models/event.dart';
import 'package:remind_me_up/services/auth.dart';

class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  final courseCollection = FirebaseFirestore.instance.collection('courses');
  final userData = FirebaseFirestore.instance.collection('user_data');

  List<Course> _coursesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map(_courseFromSnapshot).toList();
  }

  Course _courseFromSnapshot(QueryDocumentSnapshot snapshot) {
    return Course(
        uid: snapshot.id,
        name: snapshot.get('name'),
        shortName: snapshot.get('shortName'));
  }

  Future<List<Course>> get courses {
    return courseCollection
        .orderBy('name')
        .get()
        .then((v) => v.docs.map(_courseFromSnapshot).toList());
  }

  Future<Set<String>> get userCourses {
    return userData.doc(AuthService().user?.uid).get().then((value) =>
        (value.get('courses') as List).map((e) => e as String).toSet());
  }

  Stream<List<Course>> get coursesStream {
    return courseCollection
        .orderBy('name')
        .snapshots()
        .map(_coursesFromSnapshot);
  }

  void saveUserCourses(Set<String> courses) {
    userData.doc(AuthService().user?.uid).set({
      'courses': courses.toList(),
    });
  }

  Future<List<QueryDocumentSnapshot<Event>>> get userEvents async {
    var courses = (await userCourses).toList();
    print(courses);
    return await FirebaseFirestore.instance
        .collection('events')
        .withConverter<Event>(
          fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
          toFirestore: (event, _) => event.toJson(),
        )
        .get().then((snapshot) => snapshot.docs);
  }

// final List<Event> events = [
//   Event(
//     name: 'Invited talk by Prof. Pimenta Monteiro',
//     deadline: DateTime.now().add(const Duration(minutes: 22)),
//     courseId: 'ESOF',
//     duration: const Duration(hours: 2).inMicroseconds,
//     teacher: 'Ademar Aguiar',
//   ),
//   Event(
//     name: 'Teste 1',
//     courseId: 'LCOM',
//     duration: const Duration(hours: 2),
//     deadline: DateTime.now().add(const Duration(days: 1)),
//   ),
// ];
}
