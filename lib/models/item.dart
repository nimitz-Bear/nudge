// enum Priority {
//   urgent,
//   medium,
//   high,
//   low,
// }

// enum Size {

// }

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  String itemID;
  String itemName;
  String? itemDescription;
  bool done = false;
  bool isRepeating = false;
  DateTime? time;
  String? location;
  bool isReminder = false;
  List<String>? labels;

  //Labels
  //Group? (i.e. routine)

  TodoItem(
      {required this.itemID,
      required this.itemName,
      this.done = false,
      this.itemDescription,
      this.time,
      this.location,
      this.isRepeating = false,
      this.labels});

  Map<String, dynamic> toMap() {
    return {
      'itemID': itemID,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'done': done,
      'isRepeating': isRepeating,
      'time': time,
      'location': location,
      'isReminder': isReminder,
      'labels': labels
    };
  }

  void insertItem() async {
    await FirebaseFirestore.instance
        .collection('items')
        .add({toMap()} as Map<String, dynamic>);
  }
}
