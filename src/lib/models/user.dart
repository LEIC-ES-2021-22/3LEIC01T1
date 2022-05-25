import 'dart:ffi';

class UserData {
  // final String uid;
  final List<String> courses;
  final String? notificationToken;

  UserData({required this.courses, this.notificationToken});

  UserData.fromJson(Map<String, Object?> json)
      : this(
          courses: (json['courses']! as List).map((e) => e as String).toList(),
          notificationToken: json['notificationToken'] as String,
        );

  Map<String, Object?> toJson() {
    return {
      'courses': courses,
      'notificationTokens': notificationToken,
    };
  }
}
