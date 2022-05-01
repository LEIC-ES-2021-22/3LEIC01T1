class UserData {
  // final String uid;
  final List<String> courses;

  UserData({required this.courses});

  UserData.fromJson(Map<String, Object?> json)
      : this(
          courses: (json['courses']! as List).map((e) => e as String).toList(),
        );

  Map<String, Object?> toJson() {
    return {
      'courses': courses,
    };
  }
}
