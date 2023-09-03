import 'package:flutter/material.dart';

import '../models/item.dart';
import 'items_provider.dart';

class CalendarProvider with ChangeNotifier {
  static final CalendarProvider _singleton = CalendarProvider._internal();
  factory CalendarProvider() {
    return _singleton;
  }
  CalendarProvider._internal();

  List<TodoItem> _itemsForMonth = [];
  List<TodoItem> get itemsForMonth => _itemsForMonth;

  void updateCalendarView(DateTime start, DateTime end) async {
    _itemsForMonth = await ItemsProvider().getItemsForTimeRange(start, end);
    notifyListeners();
  }
}
