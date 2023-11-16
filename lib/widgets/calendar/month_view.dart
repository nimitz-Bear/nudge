import 'package:flutter/material.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/screens/item_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../providers/calendar_provider.dart';
import 'data_source.dart';

/// a widget to show the user's to do list in a month-view calendar
class MonthView extends StatefulWidget {
  const MonthView({super.key});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  final now = DateTime.now();

  DateTime earliest = DateTime.now(), latest = DateTime.now();

  @override
  void initState() {
    earliest = DateTime(now.year, now.month, 0);
    latest = DateTime(now.year, now.month + 1, 1);
    super.initState();
  }

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

  /// Open the corresponding `TodoItem` on a different screen, when an `Appointment`
  /// is clicked
  void onAppointmentClicked(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.appointments != null &&
        calendarTapDetails.appointments!.isNotEmpty) {
      TodoItem item = calendarTapDetails.appointments?.first as TodoItem;
      print(item.toMap());

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ItemPage(item: item)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Consumer<CalendarProvider>(
      builder: (context, provider, child) {
        return SfCalendar(
          initialDisplayDate: DateTime.now(),
          showTodayButton: true,
          allowedViews: [CalendarView.week, CalendarView.month],
          view: CalendarView.month,
          monthViewSettings: const MonthViewSettings(
              showAgenda: true,
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          showNavigationArrow: true,
          onTap: (calendarTapDetails) =>
              onAppointmentClicked(calendarTapDetails),
          dataSource: MeetingDataSource(provider.itemsForMonth),
          onViewChanged: (viewChangedDetails) {
            monthSelectionChanged(viewChangedDetails);
          },
        );
      },
    ));
  }
}
