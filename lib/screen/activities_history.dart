// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uthmsync5/background/custom_background.dart';

class ActivitiesHistory extends StatelessWidget {
  const ActivitiesHistory({Key? key}) : super(key: key);

  Future<bool> _onWillPop(BuildContext context) async {
    // Your logic for handling back navigation or any other actions before popping
    return true;
  }

  Future<void> _handleBackNavigation(BuildContext context) async {
    bool canPop = await _onWillPop(context);
    if (canPop) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _handleBackNavigation(context);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Activities History',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            const Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: CalendarWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Selected Date: $_selectedDay', // Display the selected date
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        TableCalendar(
          calendarFormat: _calendarFormat,
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          startingDayOfWeek: StartingDayOfWeek.sunday,
          calendarStyle: CalendarStyle(
            selectedTextStyle: const TextStyle(color: Colors.white),
            selectedDecoration: BoxDecoration(
              color: Colors.blue.withOpacity(1.0),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          headerStyle: const HeaderStyle(
            titleTextStyle: TextStyle(color: Colors.white),
            formatButtonVisible: false,
            headerPadding: EdgeInsets.zero,
          ),
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });
          },
        ),
      ],
    );
  }
}
