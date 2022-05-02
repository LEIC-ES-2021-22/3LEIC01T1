import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/auth.dart';

class CreateEvent extends StatefulWidget {
  CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final AuthService _auth = AuthService();
  final coursesList = ['AEDA', 'ES', 'LTW'];

  String? selectedCourse;
  DateTime _selectedDeadline = DateTime.now();
  // TimeOfDay _duration = TimeOfDay(hour: 0, minute: 0);
  Duration _duration = Duration.zero;
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController durationinput = TextEditingController();

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    timeinput.text = "";
    durationinput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            actions: [
              ElevatedButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        titleTextStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        title: Text(_auth.user?.displayName ??
                            _auth.user?.email ??
                            'User'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              _auth.logout();
                              Navigator.pop(context);
                            },
                            child: const Text('Sign Out'),
                          ),
                        ],
                      );
                    }),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.all(2),
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                        child: Text(
                          'Create Event',
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 400,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        // prefixIcon: Icon(Icons.person),
                        // border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        alignLabelWithHint: true,
                      ),

                      hint: const Text('Course*'),
                      value: selectedCourse,
                      isExpanded: true,
                      // iconSize: 36,
                      items: coursesList.map(buildMenuItem).toList(),
                      onChanged: (value) => setState(() {
                        selectedCourse = value;
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 400,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        // icon: const Icon(Icons.person),
                        hintText: 'Insert Event Name',
                        labelText: 'Name*',
                        contentPadding: EdgeInsets.zero,
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                                  dateinput, //editing controller of this TextField
                              decoration: const InputDecoration(
                                icon: Icon(
                                    Icons.calendar_today), //icon of text field
                                labelText: "Date", //label text of field
                                // contentPadding: EdgeInsets.zero,
                                // alignLabelWithHint: true,
                              ),
                              readOnly:
                                  true, //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDatePickerMode: DatePickerMode.day,
                                    initialDate: _selectedDeadline,
                                    firstDate: DateTime(
                                        2000), //DateTime.now() - not to allow to choose before today.
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
                                  print("Date is not selected");
                                  return;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller:
                                  timeinput, //editing controller of this TextField
                              decoration: const InputDecoration(
                                  icon: Icon(Icons
                                      .access_time_filled), //icon of text field
                                  labelText: "Time" //label text of field
                                  ),
                              readOnly:
                                  true, //set it true, so that user will not able to edit text
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: _selectedDeadline.hour,
                                        minute: _selectedDeadline.minute));
                                if (pickedTime != null) {
                                  print(pickedTime);
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
                                  print("Time is not selected");
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 12),
                  // Container(
                  //   width: 400,
                  //   child:
                  // ),
                  Container(
                    width: 400,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        // icon: const Icon(Icons.person),
                        hintText: 'Insert Location',
                        labelText: 'Location',
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 400,
                    child: TextField(
                      controller:
                          durationinput, //editing controller of this TextField
                      decoration: const InputDecoration(
                        icon:
                            Icon(Icons.access_time_filled), //icon of text field
                        labelText: "Duration", //label text of field
                      ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                                  actions: [
                                    SizedBox(
                                        height: 300,
                                        child: CupertinoTimerPicker(
                                          initialTimerDuration: _duration,
                                          mode: CupertinoTimerPickerMode.hm,
                                          onTimerDurationChanged: (duration) =>
                                              {
                                            setState(() {
                                              _duration = duration;
                                              List<String> tokens = _duration
                                                  .toString()
                                                  .split(':');
                                              durationinput.text =
                                                  tokens[0] + ':' + tokens[1];
                                            })
                                          },
                                        )),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: const Text('Cancel'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ));

                        // TimeOfDay? pickedTime = await showTimePicker(
                        //     context: context,
                        //     initialTime: TimeOfDay(
                        //         hour: _selectedDeadline.hour,
                        //         minute: _selectedDeadline.minute));
                        // if (pickedTime != null) {
                        //   print(pickedTime);
                        //   String formattedTime = pickedTime.format(context);
                        //   // print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //   //you can implement different kind of Date Format here according to your requirement
                        //   setState(() {
                        //     _selectedDeadline = DateTime(
                        //       _selectedDeadline.year,
                        //       _selectedDeadline.month,
                        //       _selectedDeadline.day,
                        //       pickedTime.hour,
                        //       pickedTime.minute,
                        //     );
                        //     timeinput.text =
                        //         formattedTime; //set output date to TextField value.
                        //   });
                        // } else {
                        //   print("Time is not selected");
                        // }
                      },
                    ),
                  ),
 
                  const SizedBox(height: 36),
                  Container(
                    width: 400,
                    child: TextFormField(
                        minLines: 12,
                        maxLines: 12,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Write a description about the event',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))))),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 40.0),
                      child: const ElevatedButton(
                        child: Text('Create'),
                        onPressed: null,
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));
}
