import 'package:flutter/material.dart';
import 'package:nudge/widgets/appbar.dart';
import 'package:nudge/widgets/calendar/month_view.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        bottomNavigationBar: MyAppBar(),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [SizedBox(height: 50), MonthView()],
          ),
        ));
  }
}
