import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/providers/calendar_provider.dart';
import 'package:nudge/providers/items_provider.dart';
import 'package:nudge/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final now = DateTime.now();
  DateTime earliest = DateTime.now(), latest = DateTime.now();

  /// find the highest and lowest dates, and get all the dates between
  void monthSelectionChanged(ViewChangedDetails viewChangedDetails) {
    earliest = viewChangedDetails.visibleDates[0];
    latest = viewChangedDetails.visibleDates[0];

    // find the latest and earliest dates

    viewChangedDetails.visibleDates.forEach((element) {
      if (element.isBefore(earliest)) {
        earliest = element;
      }

      if (element.isAfter(latest)) {
        latest = element;
      }
    });

    // add an extra day to latest to ensure it includes all events on the last visible day
    latest.add(const Duration(days: 1));

    print(earliest.toIso8601String());
    print(latest.toIso8601String());

    CalendarProvider().updateCalendarView(earliest, latest);
  }

  @override
  void initState() {
    earliest = DateTime(now.year, now.month, 0);
    latest = DateTime(now.year, now.month + 1, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const MyAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(child: Consumer<CalendarProvider>(
                builder: (context, provider, child) {
                  return SfCalendar(
                    initialDisplayDate: DateTime.now(),
                    view: CalendarView.month,
                    monthViewSettings:
                        const MonthViewSettings(showAgenda: true),
                    showNavigationArrow: true,
                    dataSource: MeetingDataSource(provider.itemsForMonth),
                    onViewChanged: (viewChangedDetails) {
                      monthSelectionChanged(viewChangedDetails);
                    },
                  );
                },
              )),
            ],
          ),
        ));
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<TodoItem> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].time;
  }

  @override
  DateTime getEndTime(int index) {
    DateTime end = appointments![index].time;

    end.add(const Duration(hours: 1));

    return end;
  }

  @override
  String getSubject(int index) {
    return appointments![index].itemName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
