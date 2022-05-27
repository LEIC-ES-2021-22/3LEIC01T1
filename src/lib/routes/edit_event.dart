import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:remind_me_up/models/course.dart';
import 'package:remind_me_up/routes/auth_wrapper.dart';
import 'package:remind_me_up/routes/home.dart';
import 'package:remind_me_up/services/database.dart';
import 'package:remind_me_up/util.dart';
import 'package:remind_me_up/models/event.dart';
import 'package:remind_me_up/services/auth.dart';

class EditEvent extends StatefulWidget {
  final Event event;
  final String eventid;

  const EditEvent({Key? key, required this.eventid, required this.event})
      : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState(event);
}

class _EditEventState extends State<EditEvent> {
  final Event event;
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;

  _EditEventState(this.event);

  List<QueryDocumentSnapshot<Course>> _coursesList = [];
  QueryDocumentSnapshot<Course>? _selectedCourse;

  final AuthService _auth = AuthService();
  DateTime _selectedDeadline = DateTime.now();
  Duration _duration = Duration.zero;
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController durationinput = TextEditingController();
  TextEditingController nameinput = TextEditingController();
  TextEditingController locationinput = TextEditingController();
  TextEditingController descriptioninput = TextEditingController();

  void getAsyncData() async {
    final courses =
        await DatabaseService().courses.then((value) => value.docs.toList());

    setState(() {
      _coursesList = courses;
      _selectedCourse = _coursesList.firstWhere((c) => c.id == event.courseId);
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _selectedDeadline=event.deadline;

    getAsyncData();
  }

  DropdownMenuItem<QueryDocumentSnapshot<Course>> buildMenuItem(
          QueryDocumentSnapshot<Course> course) =>
      DropdownMenuItem(
        value: course,
        child: RichText(
          text: TextSpan(
            text: course.data().name + ' ',
            children: [
              TextSpan(
                  text: course.data().shortName,
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DefaultAppBar(),
          SliverToBoxAdapter(
            child: _loading
                ? const SpinKitRing(
                    color: Colors.deepPurple,
                    lineWidth: 5,
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Edit Event',
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                DropdownButtonFormField<
                                    QueryDocumentSnapshot<Course>>(
                                  decoration: fixedInputDecoration.copyWith(
                                    labelText: 'Course',
                                  ),
                                  value: _selectedCourse,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                  isExpanded: true,
                                  items:
                                      _coursesList.map(buildMenuItem).toList(),
                                  onChanged: (value) =>
                                      setState(() => _selectedCourse = value),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: nameinput,
                                  decoration: fixedInputDecoration.copyWith(
                                    labelText: event.name.toString(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: dateinput,

                                        //editing controller of this TextField
                                        decoration:
                                            fixedInputDecoration.copyWith(
                                          prefixIcon:
                                              const Icon(Icons.calendar_today),
                                          labelText: 'Date',
                                        ),
                                        readOnly: true,
                                        validator: (value) {
                                          if (dateinput.text == '') {
                                            return 'This field is required';
                                          }
                                          return null;
                                        },
                                        //set it true, so that user will not able to edit text
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDatePickerMode:
                                                      DatePickerMode.day,
                                                  initialDate:
                                                      _selectedDeadline,
                                                  firstDate: DateTime.now(),
                                                  //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2101));
                                          if (pickedDate != null) {
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);
                                            setState(() {
                                              _selectedDeadline = DateTime(
                                                pickedDate.year,
                                                pickedDate.month,
                                                pickedDate.day,
                                                _selectedDeadline.hour,
                                                _selectedDeadline.minute,
                                              );
                                              dateinput.text =
                                                  formattedDate; //set output date to TextField value.
                                            });
                                          } else {
                                            if (kDebugMode) {
                                              print("Date is not selected");
                                            }
                                            return;
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        controller: timeinput,
                                        //editing controller of this TextField
                                        decoration:
                                            fixedInputDecoration.copyWith(
                                          prefixIcon: const Icon(
                                              Icons.access_time_filled),
                                          labelText: 'Time*',
                                        ),
                                        readOnly: true,
                                        validator: (value) {
                                          if (timeinput.text == '') {
                                            return 'This field is required';
                                          }
                                          if (_selectedDeadline.year ==
                                                  DateTime.now().year &&
                                              _selectedDeadline.month ==
                                                  DateTime.now().month &&
                                              _selectedDeadline.day ==
                                                  DateTime.now().day) {
                                            if (_selectedDeadline.hour ==
                                                DateTime.now().hour) {
                                              if (_selectedDeadline.minute <
                                                  DateTime.now().minute + 1) {
                                                return 'Incorrect Time';
                                              }
                                            } else if (_selectedDeadline.hour <
                                                DateTime.now().hour) {
                                              return 'Incorrect Time';
                                            }
                                          }
                                        },
                                        //set it true, so that user will not able to edit text
                                        onTap: () async {
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay(
                                                      hour: _selectedDeadline
                                                          .hour,
                                                      minute: _selectedDeadline
                                                          .minute));
                                          if (pickedTime != null) {
                                            if (kDebugMode) {
                                              print(pickedTime);
                                            }
                                            String formattedTime =
                                                pickedTime.format(context);
                                            // print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                            //you can implement different kind of Date Format here according to your requirement
                                            setState(() {
                                              _selectedDeadline = DateTime(
                                                _selectedDeadline.year,
                                                _selectedDeadline.month,
                                                _selectedDeadline.day,
                                                pickedTime.hour,
                                                pickedTime.minute,
                                              );
                                              timeinput.text =
                                                  formattedTime; //set output date to TextField value.
                                            });
                                          } else {
                                            if (kDebugMode) {
                                              print("Time is not selected");
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: locationinput,
                                  decoration: fixedInputDecoration.copyWith(
                                    prefixIcon: const Icon(Icons.location_on),
                                    labelText: event.location.toString(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: durationinput,
                                  //editing controller of this TextField

                                  decoration: fixedInputDecoration.copyWith(
                                    prefixIcon: const Icon(Icons.timer),
                                    labelText: event.duration.toString(),
                                  ),
                                  readOnly: true,
                                  //set it true, so that user will not able to edit text
                                  onTap: () async {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                        actions: [
                                          SizedBox(
                                            height: 300,
                                            child: CupertinoTimerPicker(
                                              initialTimerDuration: _duration,
                                              mode: CupertinoTimerPickerMode.hm,
                                              onTimerDurationChanged:
                                                  (duration) => {
                                                setState(
                                                  () {
                                                    _duration = duration;
                                                    List<String> tokens =
                                                        _duration
                                                            .toString()
                                                            .split(':');
                                                    durationinput.text =
                                                        tokens[0] +
                                                            ':' +
                                                            tokens[1];
                                                  },
                                                )
                                              },
                                            ),
                                          ),
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: const Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 36),
                                TextFormField(
                                  minLines: 12,
                                  maxLines: 12,
                                  keyboardType: TextInputType.multiline,
                                  controller: descriptioninput,
                                  decoration: InputDecoration(
                                    labelText: event.description.toString(),
                                    hintText:
                                        'Write a description about the event',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  child: const Text('Edit'),
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) {
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   const SnackBar(content: Text('Processing Data'))
                                      // );
                                      return;
                                    }

                                    Event editEvent = Event(
                                      name: nameinput.text,
                                      deadline: _selectedDeadline,
                                      duration: _duration,
                                      location: locationinput.text,
                                      courseId: _selectedCourse!.id,
                                      description: descriptioninput.text,
                                      teacherId: _auth.user!.uid,
                                    );
                                    DatabaseService()
                                        .editEvent(editEvent, widget.eventid);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AuthWrapper()));
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
