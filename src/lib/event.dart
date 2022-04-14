import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remind_me_up/util.dart';

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

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  SizedBox durationBox(Duration dur) {
    final rounded = Util.maxTersity(dur);
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Text(
            rounded[0].toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            rounded[1].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () => Navigator.pushNamed(context, '/event', arguments: event),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.school, size: 15),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(event.course),
                        const SizedBox(width: 15),
                        if (event.teacher != null)
                          Row(
                            children: [
                              const Icon(Icons.person, size: 15),
                              const SizedBox(width: 5),
                              Text(event.teacher!),
                            ],
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 15),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(DateFormat("HH:MM E, dd MMMM yyyy")
                            .format(event.deadline)),
                        const SizedBox(
                          width: 15,
                        ),
                        if (event.duration != null)
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, size: 15),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(Util.formattedDuration(event.duration!)),
                            ],
                          )
                      ],
                    ),
                  ],
                ),
              ),
              durationBox(event.deadline.difference(DateTime.now())),
            ],
          ),
        ),
      ),
    );
  }
}
