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
  String? link;
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
      this.link,
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
      'link': link,
      'location': location,
      'isReminder': isReminder,
      'labels': labels
    };
  }

  void insertItem() async {
    var db = FirebaseFirestore.instance;
    // await FirebaseFirestore.instance
    //     .collection('items')
    //     .add({toMap()});

    // CollectionReference items = FirebaseFirestore.instance.collection('items');

    // items.add({TodoItem(itemID: "test", itemName: "map").toMap()});
    db
        .collection("items")
        .doc(itemID)
        .set(toMap())
        .onError((e, _) => print("Error writing document: $e"));
  }
}
