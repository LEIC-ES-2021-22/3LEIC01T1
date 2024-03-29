import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remind_me_up/models/course.dart';
import 'package:remind_me_up/models/event.dart';
import 'package:remind_me_up/models/user.dart';
import 'package:remind_me_up/services/auth.dart';
import 'package:remind_me_up/services/pushNotification.dart';

class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  final coursesRef =
      FirebaseFirestore.instance.collection('courses').withConverter<Course>(
            fromFirestore: (snapshot, _) => Course.fromJson(snapshot.data()!),
            toFirestore: (course, _) => course.toJson(),
          );

  final userDataRef =
      FirebaseFirestore.instance.collection('userData').withConverter<UserData>(
            fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
            toFirestore: (userData, _) => userData.toJson(),
          );

  final eventsRef =
      FirebaseFirestore.instance.collection('events').withConverter<Event>(
            fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
            toFirestore: (event, _) => event.toJson(),
          );

  Future<QuerySnapshot<Course>> get courses {
    return coursesRef.orderBy('name').get();
  }

  Future<UserData?> get userData {
    return userDataRef
        .doc(AuthService().user!.uid)
        .get()
        .then((value) => value.data());
  }

  Future<List<QueryDocumentSnapshot<Course>>> get userCoursesM async {
    final data = await userData;

    if (data == null || data.courses.isEmpty) {
      return [];
    }

    return coursesRef
        .where(FieldPath.documentId, whereIn: data.courses.toList())
        .get()
        .then((value) => value.docs);
  }

  void saveUserCourses(Set<String> courses) {
    userDataRef.doc(AuthService().user?.uid).set(
          UserData(courses: courses.toList()),
          SetOptions(mergeFields: ['courses']),
        );
  }

  void saveUserNotificationToken(String? token) async{
    await FirebaseFirestore.instance.collection("userData").doc(AuthService().user?.uid).set({
      'notificationToken':token,
    }, SetOptions(mergeFields: ['notificationToken']));
  }
  void sendNotification(String courseId, String title, String body) async{
    final userDataRef = FirebaseFirestore.instance.collection("userData");
    userDataRef.where("courses", arrayContains: courseId).get().then((value){
      for (var val in value.docs) {
        var notificationToken = val.data()['notificationToken'];
        if(notificationToken!=null){
          PushNotification().sendPushMessage(notificationToken, body, title);
        }
      }
    } );  
  }

  void saveUserRole(int role) async{
    await FirebaseFirestore.instance.collection("userData").doc(AuthService().user?.uid).set({
      'role':role,
    }, SetOptions(mergeFields: ['role']));
  }


  Future<int> hasPermission() async {
    var userRef = await userData;
    return userRef?.role ?? 0;
  }

  void createEvent(Event event){
    // print(event);
    eventsRef.add(event);
  }

  void editEvent(Event event,String id){
    // print(event);
    eventsRef.doc(id).set(event);
  }

  Future<List<QueryDocumentSnapshot<Event>>> get userEvents async {
    final courses = await userCoursesM;

    if (courses.isEmpty) {
      return [];
    }

    return await eventsRef
        .where('courseId', whereIn: courses.map((c) => c.id).toList())
        .where('deadline', isGreaterThan: DateTime.now())
        .orderBy('deadline')
        .get()
        .then((snapshot) => snapshot.docs);
  }
}
