class Course {
  // final String uid;
  final String name;
  final String shortName;

  Course({required this.name, required this.shortName});

  Course.fromJson(Map<String, Object?> json)
      : this(
    name: json['name']! as String,
    shortName: json['shortName']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'shortName': shortName,
    };
  }

  @override
  String toString() {
    return '($shortName)$name';
  }
}
