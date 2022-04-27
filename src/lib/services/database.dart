import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remind_me_up/models/course.dart';
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

// UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
//   return UserData(
//     uid: uid,
//     courses:
//         (snapshot.get('courses') as List).map((id) => id as String).toSet(),
//   );
// }
//
// Stream<UserData?> get userData {
//   return FirebaseFirestore.instance
//       .collection('user_data')
//       .doc(uid)
//       .snapshots()
//       .map(_userDataFromSnapshot);
// }

// final CollectionReference eventCollection = FirebaseFirestore.instance.collection('events');
}
