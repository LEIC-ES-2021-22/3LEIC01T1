import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String name;
  DateTime deadline;
  String courseId;
  String teacherId;
  String teacherName;

  String? description;
  Duration? duration;
  String? location;

  Event({
    required this.name,
    required this.deadline,
    required this.courseId,
    required this.teacherId,
    required this.teacherName,
    this.description,
    this.duration,
    this.location,
  });

  Event.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          deadline: (json['deadline']! as Timestamp).toDate(),
          courseId: json['courseId']! as String,
          teacherId: json['teacherId']! as String,
          description: json['description'] as String?,
          teacherName: json['teacherName'] as String,
          duration: json['duration'] != null
              ? Duration(seconds: json['duration']! as int)
              : null,
          location: json['location'] as String?,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'deadline': deadline,
      'courseId': courseId,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'description': description,
      'duration': duration?.inSeconds,
      'location': location,
    };
  }
}
