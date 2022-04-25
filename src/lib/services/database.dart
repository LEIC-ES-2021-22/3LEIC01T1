import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remind_me_up/models/course.dart';

class DatabaseService {
  final String uid;

  final CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');

  DatabaseService({required this.uid});

  List<Course> _coursesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map(
          (d) => Course(
            uid: d.id,
            name: d.get('name'),
            shortName: d.get('shortName'),
          ),
        )
        .toList();
  }

  Stream<List<Course>> get courses {
    return courseCollection
        .orderBy('name')
        .snapshots()
        .map(_coursesFromSnapshot);
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
