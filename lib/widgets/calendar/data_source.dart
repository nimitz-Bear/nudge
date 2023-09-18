import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/item.dart';

/// This helper class decides how to read data from `ToDoItem`s into a
/// calendar widget
///
///
/// See also:
/// - [TodoItem]
/// - [MonthView]
/// - [WeekView]
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<TodoItem> source) {
    appointments = source;
  }

  @override
  Object? convertAppointmentToObject(
      Object? customData, Appointment appointment) {
    if (customData is TodoItem) {
      print("nice");
    } else {
      print("bugger");
    }

    TodoItem item = customData as TodoItem;

    return Appointment(
        startTime: item.startTime!,
        endTime: item.startTime!.add(const Duration(minutes: 30)));
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  // defaults all appointments to ~30 minutes (if null)
  @override
  DateTime getEndTime(int index) {
    DateTime end =
        appointments![index].startTime?.add(const Duration(minutes: 30));

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
