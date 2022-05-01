import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remind_me_up/models/course.dart';
import 'package:remind_me_up/routes/event_description.dart';
import 'package:remind_me_up/util.dart';

import 'package:remind_me_up/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final Course course;

  const EventCard({Key? key, required this.event, required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () => //Navigator.pushNamed(context, '/event', arguments: event),
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  EventDescription(event: event)),
        ),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 15,
                      runSpacing: 5,
                      children: [
                        IconWithText(icon: Icons.school, text: course.shortName),
                        // IconWithText(
                        //   icon: Icons.person,
                        //   text: event.teacherId,
                        // ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 15,
                      runSpacing: 5,
                      children: [
                        IconWithText(
                          icon: Icons.calendar_month,
                          text: DateFormat("HH:MM E, dd MMMM yyyy")
                              .format(event.deadline),
                        ),
                        if (event.duration != null)
                          IconWithText(
                            icon: Icons.timer_outlined,
                            text: FlooredDuration.fromDuration(event.duration!)
                                .formatted(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              FlooredDurationBox.fromDuration(
                event.deadline.difference(DateTime.now()),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FlooredDurationBox extends StatelessWidget {
  final FlooredDuration duration;

  const FlooredDurationBox({
    Key? key,
    required this.duration,
  }) : super(key: key);

  static FlooredDurationBox fromDuration(Duration duration) {
    return FlooredDurationBox(duration: FlooredDuration.fromDuration(duration));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      child: Column(
        children: [
          Text(
            duration.amount.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.deepPurple.shade300,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            duration.pluralizedTersity().toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;
  final double iconSize;

  const IconWithText({
    Key? key,
    required this.icon,
    required this.text,
    this.iconSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: iconSize),
        const SizedBox(
          width: 5,
        ),
        Text(text),
      ],
    );
  }
}
