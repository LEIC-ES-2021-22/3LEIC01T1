import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remind_me_up/event_card.dart';
import 'package:remind_me_up/models/event.dart';
import 'package:remind_me_up/util.dart';

class EventDescription extends StatelessWidget {
  final Event event;

  const EventDescription({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            /*
        centerTitle: true,
        title: Text("Description"),
        */
            floating: true,
            actions: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                ),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/okayeg.png'),
                ),
              ),
              const SizedBox(width: 15)
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(height: 5),
                      Flexible(
                        child: Text(event.name,
                            style: const TextStyle(
                              fontSize: 20,
                            )),
                      ),
                      FlooredDurationBox.fromDuration(
                        event.deadline.difference(DateTime.now()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                      event.courseId + " • " + event.teacherId,
                      style: const TextStyle(color: Color(0xAAFFFFFF))),
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
                    ],
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 15,
                    runSpacing: 5,
                    children: [
                      IconWithText(
                        icon: Icons.timer_outlined,
                        text: FlooredDuration.fromDuration(event.duration!)
                            .formatted(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(event.description ?? "no  description",
                      style: const TextStyle(fontSize: 20, height: 1.8))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
