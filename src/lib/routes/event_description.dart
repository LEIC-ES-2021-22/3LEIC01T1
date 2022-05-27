import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:remind_me_up/event_card.dart';
import 'package:remind_me_up/models/course.dart';
import 'package:remind_me_up/models/event.dart';
import 'package:remind_me_up/routes/home.dart';
import 'package:remind_me_up/routes/edit_event.dart';
import 'package:remind_me_up/services/database.dart';
import 'package:remind_me_up/util.dart';

class EventDescription extends StatelessWidget {
  final Event event;
  final String eventid;
  const EventDescription({Key? key, required this.eventid, required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DefaultAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          event.name,
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      FlooredDurationBox.fromDeadline(event.deadline),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<DocumentSnapshot<Course>>(
                    future:
                        DatabaseService().coursesRef.doc(event.courseId).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: const [
                            SpinKitRing(
                              color: Colors.grey,
                              lineWidth: 2,
                              size: 15,
                            ),
                          ],
                        );
                      }

                      if (snapshot.hasData && snapshot.data!.data() != null) {
                        return Text(
                          snapshot.data!.data()!.name +
                              " (" +
                              snapshot.data!.data()!.shortName +
                              ") • " +
                              event.teacherName.split('@')[0],
                          style: const TextStyle(color: Colors.grey),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 15,
                    runSpacing: 5,
                    children: [
                      IconWithText(
                        icon: Icons.calendar_month,
                        text: DateFormat("HH:mm E, dd MMMM yyyy")
                            .format(event.deadline),
                        iconSize: 28,
                        textSize: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (event.duration != null)
                    (Wrap(
                      spacing: 15,
                      runSpacing: 5,
                      children: [
                        IconWithText(
                          icon: Icons.timer_outlined,
                          text: FlooredDuration.fromDuration(event.duration!)
                              .formatted(),
                          iconSize: 30,
                        ),
                      ],
                    )),
                  const SizedBox(height: 20),
                  Text(event.description ?? "no  description",
                      style: const TextStyle(fontSize: 18, height: 1.8)),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditEvent(eventid: eventid, event: event)),
                      );
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
