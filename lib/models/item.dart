import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nudge/providers/items_provider.dart';

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

      //update the provider
      // ItemsProvider().getItemsForDay(time ?? DateTime.now());
      // ItemsProvider().getList(time ?? DateTime.now());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // create a new document in the firebase collection
  void insertNewItem() async {
    var db = FirebaseFirestore.instance;

    // let firebase generate a unique key for the document
    var id = FirebaseFirestore.instance.collection("items").doc().id;
    itemID = id;

    db
        .collection("items")
        .doc(id)
        .set(toMap())
        .onError((e, _) => print("Error writing document: $e"));

    ItemsProvider().getList(DateTime.now());
  }

  void deleteItem() async {
    var collection = FirebaseFirestore.instance.collection('items');
    await collection.doc(itemID).delete();

    // update the provider to show the item as deleted
    ItemsProvider().getList(DateTime.now());
  }
}
