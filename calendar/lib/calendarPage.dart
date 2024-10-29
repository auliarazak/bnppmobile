import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';

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

  // This function shows the Date Range Picker and adds the markers
  Future<void> _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        DateTime startDate = _normalizeDate(picked.start);
        DateTime endDate = _normalizeDate(picked.end);

        for (DateTime day = startDate;
            day.isBefore(endDate) || day.isAtSameMomentAs(endDate);
            day = day.add(Duration(days: 1))) {
          DateTime normalizedDay = _normalizeDate(day);
          if (_markedDates.containsKey(normalizedDay)) {
            _markedDates[normalizedDay]?.add('Marked');
          } else {
            _markedDates[normalizedDay] = ['Marked'];
          }
        }
      });
    }
  }

  // Function to build event markers (dots) with different colors
  List<Widget> _buildEventMarkers(List events) {
    List<Color> markerColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ];

    return events.asMap().entries.map((entry) {
      int index = entry.key;
      return Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: markerColors[index % markerColors.length], // Use different color for each event
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
                color: const Color.fromARGB(255, 246, 251, 255),
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
                        markerSize: 8.0,
                        markerDecoration: BoxDecoration(), // Remove default marker styling
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
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
                    // Positioned "+" button at the bottom left
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: FloatingActionButton(
                        onPressed: _pickDateRange,
                        child: Icon(Icons.add),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              // Right side for any other content
              Container(
                width: rightSideWidth,
                color: Colors.green,
                child: Center(
                  child: Text(
                    'Right Side (1/4)',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
