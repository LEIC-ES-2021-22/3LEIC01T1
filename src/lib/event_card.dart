import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remind_me_up/util.dart';

import 'package:remind_me_up/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  SizedBox durationBox(Duration dur) {
    final rounded = Util.maxTersity(dur);
    return SizedBox(
      width: 75,
      child: Column(
        children: [
          Text(
            rounded.amount.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.deepPurple.shade300),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            rounded.pluralizedTersity().toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    Wrap(
                      spacing: 15,
                      runSpacing: 5,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.school, size: 16),
                            const SizedBox(width: 5),
                            Text(event.course),
                          ],
                        ),
                        if (event.teacher != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person, size: 16),
                              const SizedBox(width: 5),
                              Text(event.teacher!),
                            ],
                          )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 15,
                      runSpacing: 5,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_month, size: 16),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(DateFormat("HH:MM E, dd MMMM yyyy")
                                .format(event.deadline)),
                          ],
                        ),
                        if (event.duration != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_outlined, size: 16),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                  Util.maxTersity(event.duration!).formatted()),
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
