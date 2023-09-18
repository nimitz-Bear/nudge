import 'package:flutter/material.dart';
import 'package:nudge/widgets/appbar.dart';
import 'package:nudge/widgets/calendar/month_view.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        bottomNavigationBar: MyAppBar(),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              MonthView(),
            ],
          ),
        ));
  }
}
