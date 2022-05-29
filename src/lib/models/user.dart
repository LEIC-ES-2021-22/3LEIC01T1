import 'dart:ffi';

class UserData {
  // final String uid;
  final List<String> courses;
  final String? notificationToken;
  final int? role;

  UserData({required this.courses, this.notificationToken, this.role});

  UserData.fromJson(Map<String, Object?> json)
      : this(
          courses: json['courses'] != null? (json['courses']! as List).map((e) => e as String).toList() : List.empty(),
          notificationToken: json['notificationToken'] as String?,
          role: json['role'] != null?  json['role'] as int : 0,
        );

  Map<String, Object?> toJson() {
    return {
      'courses': courses,
      'notificationTokens': notificationToken,
      'role': role,
    };
  }
}
