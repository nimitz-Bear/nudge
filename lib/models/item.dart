import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  String itemID = "";
  String itemName;
  String? itemDescription;
  bool done = false;
  bool isRepeating = false;
  DateTime? time;
  String? location;
  String? link;
  bool isReminder = true;
  List<String>? labels;

  //Labels
  //Group? (i.e. routine)

  TodoItem(
      {required this.itemName,
      required this.itemID,
      this.done = false,
      this.isRepeating = false,
      this.itemDescription,
      this.time,
      this.location,
      this.link,
      this.isReminder = true,
      this.labels});

  Map<String, dynamic> toMap() {
    return {
      'itemID': itemID,
      'itemName': itemName,
      'itemDescription': itemDescription ?? "",
      'done': done,
      'isRepeating': isRepeating,
      'time': time
          ?.millisecondsSinceEpoch, //TODO: come up with some kind of null safety for this
      'link': link ?? "",
      'location': location ?? "",
      'isReminder': isReminder,
      'labels': labels ?? []
    };
  }

  // static Question fromMap(Map<String, dynamic> map) {
  //   return Question(
  //     map['text'],
  //     map['answer'],
  //     map['correctAnswer'].ToString() == 'true'
  //   );
  // }
  static TodoItem fromMap(Map<String, dynamic> map) {
    // print(map['labels']);
    return TodoItem(
        itemID: map['itemID'] ?? "",
        itemName: map['itemName'] ?? "",
        itemDescription: map['itemDescription'] ?? "",
        done: map['done'],
        isRepeating: map['isRepeating'],
        time: DateTime.fromMillisecondsSinceEpoch(map['time']),
        // DateTime.now()
        // , //FIXME: do some kind of null checking for this
        link: map['link'] ?? "",
        location: map['location'] ?? "",
        isReminder: map['isReminder'],
        labels: List<String>.from(map['labels'] ?? []));
  }

  void updateItem() async {
    var collection = FirebaseFirestore.instance.collection('items');
    collection
        .doc(itemID) // <-- Doc ID where data should be updated.
        .update(toMap());
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

//TODO: delete function
