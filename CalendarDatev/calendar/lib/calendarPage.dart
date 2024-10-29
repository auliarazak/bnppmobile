import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List> _markedDates = {}; // Store marked dates
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Set orientation to landscape only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Reset orientation preferences when leaving the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // Helper function to normalize the DateTime (removing time portion)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Helper function to format time
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  // Function to open a form popup for adding an event
  Future<void> _openAddEventForm() async {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    DateTime? startDate;
    DateTime? endDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    String location = '';
    Color selectedColor = Colors.red;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Title input
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      title = value!;
                    },
                  ),
                  // Description input
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    onSaved: (value) {
                      description = value ?? '';
                    },
                  ),
                  // Start date input
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Start Date'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        initialDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                        text: startDate != null
                            ? DateFormat('yyyy-MM-dd').format(startDate!)
                            : ''),
                  ),
                  // End date input
                  TextFormField(
                    decoration: InputDecoration(labelText: 'End Date'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        initialDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                        text: endDate != null
                            ? DateFormat('yyyy-MM-dd').format(endDate!)
                            : ''),
                  ),
                  // Start time input
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Start Time'),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          startTime = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                        text: startTime != null ? _formatTime(startTime!) : ''),
                  ),
                  // End time input
                  TextFormField(
                    decoration: InputDecoration(labelText: 'End Time'),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          endTime = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                        text: endTime != null ? _formatTime(endTime!) : ''),
                  ),
                  // Location input
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Location'),
                    onSaved: (value) {
                      location = value ?? '';
                    },
                  ),
                  // Color picker
                  DropdownButtonFormField<Color>(
                    decoration: InputDecoration(labelText: 'Event Color'),
                    value: selectedColor,
                    items: [
                      DropdownMenuItem(
                        value: Colors.red,
                        child: Text('Red'),
                      ),
                      DropdownMenuItem(
                        value: Colors.green,
                        child: Text('Green'),
                      ),
                      DropdownMenuItem(
                        value: Colors.blue,
                        child: Text('Blue'),
                      ),
                      DropdownMenuItem(
                        value: Colors.orange,
                        child: Text('Orange'),
                      ),
                      DropdownMenuItem(
                        value: Colors.purple,
                        child: Text('Purple'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedColor = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    // Mark the date range in the calendar
                    DateTime sDate = _normalizeDate(startDate!);
                    DateTime eDate = _normalizeDate(endDate!);

                    for (DateTime day = sDate;
                        day.isBefore(eDate) || day.isAtSameMomentAs(eDate);
                        day = day.add(Duration(days: 1))) {
                      DateTime normalizedDay = _normalizeDate(day);
                      if (_markedDates.containsKey(normalizedDay)) {
                        _markedDates[normalizedDay]?.add({
                          'title': title,
                          'description': description,
                          'location': location,
                          'color': selectedColor,
                          'startTime': startTime,
                          'endTime': endTime
                        });
                      } else {
                        _markedDates[normalizedDay] = [
                          {
                            'title': title,
                            'description': description,
                            'location': location,
                            'color': selectedColor,
                            'startTime': startTime,
                            'endTime': endTime
                          }
                        ];
                      }
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to build event markers (dots) with different colors
  List<Widget> _buildEventMarkers(List events) {
    return events.asMap().entries.map((entry) {
      int index = entry.key;
      Map event = entry.value;
      return Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: event['color'], // Use event color
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double totalWidth = constraints.maxWidth;
          double leftSideWidth = totalWidth * 0.75;
          double rightSideWidth = totalWidth * 0.25;

          return Row(
            children: [
              // Left side for Calendar
              Container(
                width: leftSideWidth,
                color: Color.fromARGB(255, 250, 253, 255),
                child: Stack(
                  children: [
                    // Calendar widget
                    TableCalendar(
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      firstDay: DateTime(2000),
                      lastDay: DateTime(2100),
                      eventLoader: (date) {
                        return _markedDates[_normalizeDate(date)] ?? [];
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        markersAlignment: Alignment.bottomCenter,
                        markersMaxCount: 5,
                        markerDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 38, 122, 31), // Default marker color
                          shape: BoxShape.circle,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          if (events.isNotEmpty) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildEventMarkers(events),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                    // Floating button to add event
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: _openAddEventForm, // Open event form
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
              // Right side for agenda
              Container(
                width: rightSideWidth,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: _markedDates.containsKey(_normalizeDate(_focusedDay))
                          ? ListView.builder(
                              itemCount:
                                  _markedDates[_normalizeDate(_focusedDay)]!.length,
                              itemBuilder: (context, index) {
                                var event = _markedDates[_normalizeDate(_focusedDay)]![index];
                                return Card(
                                  color: event['color'], // Use event color
                                  child: ListTile(
                                    title: Text(event['title']),
                                    subtitle: Text('${event['description']} \n'
                                        'Location: ${event['location']} \n'
                                        'Time: ${_formatTime(event['startTime'])} - ${_formatTime(event['endTime'])}'),
                                  ),
                                );
                              },
                            )
                          : Center(child: Text('No Events')),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
