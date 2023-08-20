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
  int position = -1;

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
      this.labels,
      this.position = -1});

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
      'labels': labels ?? [],
      'position': position
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
        labels: List<String>.from(map['labels'] ?? []),
        position: map['position']);
  }

  // update the firebase document with the flutter objec'ts fields
  Future<bool> updateItem() async {
    final collection = FirebaseFirestore.instance.collection('items');

    try {
      collection
          .doc(itemID) // <-- Doc ID where data should be updated.
          .update(toMap());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }

    // var collection = FirebaseFirestore.instance.collection('items');
    // collection
    //     .doc(itemID) // <-- Doc ID where data should be updated.
    //     .update(toMap());
  }

  // create a new document in the firebase collection
  void insertItem() async {
    var db = FirebaseFirestore.instance;

    db
        .collection("items")
        .doc(itemID)
        .set(toMap())
        .onError((e, _) => print("Error writing document: $e"));
  }

  void deleteItem() async {
    var collection = FirebaseFirestore.instance.collection('items');
    await collection.doc(itemID).delete();
  }

  // // overwrite this item with the `toMap()` of another TodoItem
  // void _overwriteItem(Map<String, dynamic> map) {
  //   fromMap(map); //FIXME: this probably wont work
  // }

  // // switch this todo item and another todo item
  // TodoItem switchItem(TodoItem other) {
  //   Map<String, dynamic> temp = other.toMap();

  //   //overwrite the other TodoItem with this item's info
  //   // other.fromMap(toMap());
  //   other._overwriteItem(toMap());

  //   // overwrite this item with Other's info
  //   _overwriteItem(temp);

  //   return other;
  // }
}
