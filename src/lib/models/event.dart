import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String name;
  Timestamp deadline;
  String courseId;
  String teacherId;

  String? description;
  Duration? duration;
  String? location;

  Event({
    required this.name,
    required this.deadline,
    required this.courseId,
    required this.teacherId,
    this.description,
    this.duration,
    this.location,
  });

  Event.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          deadline: json['deadline']! as Timestamp,
          courseId: json['courseId']! as String,
          teacherId: json['teacherId']! as String,
          description: json['description'] as String?,
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
      if (description != null) 'description': description,
      if (duration != null) 'duration': duration!.inSeconds,
      if (location != null) 'location': location,
    };
  }
}
