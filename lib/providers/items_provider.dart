import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/providers/user_provider.dart';

class ItemsProvider with ChangeNotifier {
  static final ItemsProvider _singleton = ItemsProvider._internal();
  factory ItemsProvider() {
    return _singleton;
  }
  ItemsProvider._internal();

  List<TodoItem> _todayToDoList = [];
  List<TodoItem> get todayToDoList => _todayToDoList;
  List<TodoItem> _tommorowToDoList = [];
  List<TodoItem> get tommorowToDoList => _tommorowToDoList;

  void getList(DateTime date) async {
    _todayToDoList = await getItemsForDay(date);
    _tommorowToDoList =
        await getItemsForDay(DateTime.now().add(const Duration(days: 1)));
    notifyListeners();
  }

  // get all the items from firebase, from 00:00 till 23:59:59 on the input date
  // WHERE the user is the currently logged in user
  Future<List<TodoItem>> getItemsForDay(DateTime date) async {
    DateTime startOfDay =
        DateTime(date.year, date.month, date.day); // Set time to midnight
    DateTime endOfDay = startOfDay
        .add(const Duration(days: 1)); // set end time to midnight the next day

    return await getItemsForTimeRange(startOfDay, endOfDay);
  }

  /// gets all TodoItems for the currently logged in user between two time stamps
  /// (inclusive of [start], exclusive of [end])
  Future<List<TodoItem>> getItemsForTimeRange(
      DateTime start, DateTime end) async {
    List<TodoItem> todoItems = [];

    await FirebaseFirestore.instance
        .collection("items")
        .where('users', arrayContains: UserProvider().getCurrentUserId())
        .where('time', isGreaterThanOrEqualTo: start.millisecondsSinceEpoch)
        .where('time', isLessThan: end.millisecondsSinceEpoch)
        .get()
        .then((value) {
      List<Map<String, dynamic>> data = [];

      for (var i in value.docs) {
        data.add(i.data());
      }

      for (var element in data) {
        todoItems.add(TodoItem.fromMap(element));
      }
    });

    // notifyListeners();
    return todoItems;
  }

  void changeOrderToday(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    // // store old Index Position
    // int tempPosition = widget.items[oldIndex].position;

    // // swap position of new and old index
    // widget.items[oldIndex].position = widget.items[newIndex].position;

    final item = _todayToDoList.removeAt(oldIndex);
    _todayToDoList.insert(newIndex, item);

    for (int i = 0; i < _todayToDoList.length; i++) {
      _todayToDoList[i].position = i;
      print(_todayToDoList[i].toMap());
      _todayToDoList[i].updateItem();
    }
    notifyListeners();
  }

  void changeOrderTomorrow(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;

    // // store old Index Position
    // int tempPosition = widget.items[oldIndex].position;

    // // swap position of new and old index
    // widget.items[oldIndex].position = widget.items[newIndex].position;

    final item = _tommorowToDoList.removeAt(oldIndex);
    _tommorowToDoList.insert(newIndex, item);

    for (int i = 0; i < _tommorowToDoList.length; i++) {
      _tommorowToDoList[i].position = i;
      _tommorowToDoList[i].updateItem();
    }
    notifyListeners();
  }
}
