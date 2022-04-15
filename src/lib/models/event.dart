class Event {
  String name;
  DateTime deadline;
  String course;

  String? teacher;
  String? description;
  Duration? duration;
  String? location;

  Event({
    required this.name,
    required this.deadline,
    required this.course,
    this.description,
    this.duration,
    this.location,
    this.teacher,
  });
}
