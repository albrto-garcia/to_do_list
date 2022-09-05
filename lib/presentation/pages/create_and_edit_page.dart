import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase/data/models/task_model.dart';
import 'package:firebase/data/remote_data_source/firestore_helper.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class CreateAndEditPage extends StatefulWidget {
  final TaskModel? task;
  final String pageToShow;

  const CreateAndEditPage({Key? key, this.task, required this.pageToShow})
      : super(key: key);

  @override
  State<CreateAndEditPage> createState() => _CreateAndEditPageState();
}

class _CreateAndEditPageState extends State<CreateAndEditPage> {
  TextEditingController? _nameController;
  TextEditingController? _descriptionController;
  String? _creationDate;
  String? _rememberDate;
  String _dateTimeString = "Not set";
  String _date = "Not set";
  bool _completedValue = false;
  late Timer _timer = Timer(const Duration(milliseconds: 1), () {});

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.task!.name);
    _descriptionController =
        TextEditingController(text: widget.task!.description);
    _creationDate = widget.task!.creationDate;
    _rememberDate = widget.task!
        .rememberDate; /* DateFormat('dd/MM/yyyy hh:mm:ss a').format(
        DateTime.parse(widget.task!.rememberDate ?? '9999-12-31 00:00:00')); */
    _completedValue = widget.task!.completed ?? false;
    _dateTimeString = _formatDateTime(DateTime.now());

    if (widget.pageToShow == 'CreatePage') {
      /* if (_timer == null) {
        _timer.cancel();
      } else { */
      _timer =
          Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
      //}
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController!.dispose();
    _descriptionController!.dispose();
    _timer.cancel();
    //_creationDate!.dispose();
    //_rememberDate!.dispose();
    //_completedController!.dispose();
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _dateTimeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.pageToShow == 'CreatePage' ? 'Create' : 'Update'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: const TextStyle(fontSize: 20),
                controller: _nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  hintText: "Name",
                  hintStyle: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 20),
                maxLength: 200,
                maxLines: 3,
                controller: _descriptionController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    hintText: "Description",
                    hintStyle: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(
                height: 10,
              ),
              IgnorePointer(
                ignoring: true,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
                    side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.black,
                      width: 2,
                    )),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                  ),
                  /* ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    //elevation: 4.0,
                    backgroundColor: Colors.white,
                  ), */
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: const DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                      _creationDate = date.toString();
                      _date = DateFormat('dd/MM/yyyy hh:mm:ss a').format(date);
                      print(
                          'Date: $date | Creation Date: $_creationDate | _Date: $_date');
                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.es);
                  },
                  //color: Colors.white,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.date_range,
                                    size: 20.0,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    widget.pageToShow == 'CreatePage'
                                        ? " $_dateTimeString"
                                        : " $_creationDate",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        /* 
                                        fontWeight: FontWeight.bold, */
                                        fontSize: 20.0),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                  side: MaterialStateProperty.all(const BorderSide(
                    color: Colors.black,
                    width: 2,
                  )),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                ),
                /* shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                elevation: 4.0, */
                onPressed: () {
                  DatePicker.showDateTimePicker(context,
                      theme: const DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(
                        9999,
                        12,
                        31,
                      ), onConfirm: (date) {
                    _rememberDate = date.toString();
                    _date = DateFormat('yyyy-MM-dd hh:mm:ss').format(date);
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
                //color: Colors.white,
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.date_range,
                                  size: 20.0,
                                  color: Colors.black,
                                ),
                                Text(
                                  widget.pageToShow == 'CreatePage'
                                      ? " $_date"
                                      : " ${_rememberDate?.compareTo('9999-12-31 00:00:00') == 0 ? 'Not set' : _rememberDate}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      /* 
                                      fontWeight: FontWeight.bold, */
                                      fontSize: 20.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      /* const Text(
                        "  Change",
                        style: TextStyle(
                            color: Colors.black,
                            /* 
                            fontWeight: FontWeight.bold, */
                            fontSize: 20),
                      ), */
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text('Completed: ', style: TextStyle(fontSize: 20)),
                  Switch(
                      // This bool value toggles the switch.
                      value: _completedValue,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          _completedValue = value;
                        });
                      }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (widget.pageToShow == 'CreatePage') {
                    _creationDate = _dateTimeString;

                    FirestoreHelper.create(TaskModel(
                      id: widget.task!.id,
                      name: _nameController!.text,
                      description: _descriptionController!.text,
                      creationDate: _creationDate,
                      rememberDate: _rememberDate == null
                          ? '9999-12-31 00:00:00'
                          : _rememberDate,
                      completed: _completedValue,
                    )).then((value) {
                      Navigator.pop(context);
                    });
                  } else {
                    FirestoreHelper.update(
                      TaskModel(
                          id: widget.task!.id,
                          name: _nameController!.text,
                          description: _descriptionController!.text,
                          creationDate: _creationDate,
                          rememberDate: _rememberDate,
                          completed: _completedValue),
                    ).then((value) {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.pageToShow == 'CreatePage' ? 'Create' : 'Update',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
