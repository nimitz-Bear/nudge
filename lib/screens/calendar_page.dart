import 'package:flutter/material.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/providers/items_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: ItemsProvider().getItemsForDay(DateTime.now()),
              builder: (context, snapshot) {
                // check if there is an error gettign the data
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong!"));
                }

                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else {
                  return SfCalendar(
                    initialDisplayDate: DateTime.now(),
                    view: CalendarView.month,
                    monthViewSettings:
                        const MonthViewSettings(showAgenda: true),
                    showNavigationArrow: true,
                    dataSource: MeetingDataSource(snapshot.data ?? []),
                  );
                }
              },
            ),

            // child: Consumer<ItemsProvider>(
            //   builder: (context, provider, _) {}
            //     items = await provider.getItemsForDay(DateTime.now());
            //     return SfCalendar(
            //       initialDisplayDate: DateTime.now(),
            //       view: CalendarView.month,
            //       monthViewSettings: const MonthViewSettings(showAgenda: true),
            //       showNavigationArrow: true,
            //       dataSource: MeetingDataSource(items),
            //     );
            //   },
            // ),
          ),
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
    return Colors.greenAccent;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
