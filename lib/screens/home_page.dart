import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/screens/individual_page.dart';
import 'package:nudge/widgets/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO: change this to use firebase
  // List<TodoItem> todayToDoList = [
  //   TodoItem(
  //     itemID: "testID",
  //     itemName: "Make lunch",
  //   ),
  // ];
  List<TodoItem> todayToDoList = [];

  void deleteTask(TodoItem item, int index) {
    setState(() {
      todayToDoList.removeAt(index);
    });
  }

  Future<List<TodoItem>> getItems() async {
    List<TodoItem> items = [];

    await FirebaseFirestore.instance.collection("items").get().then((value) {
      List<Map<String, dynamic>> data = [];

      for (var i in value.docs) {
        data.add(i.data());
      }

      for (var element in data) {
        items.add(TodoItem.fromMap(element));
      }

      items.forEach((element) {
        print(element.toMap());
      });
    });

    // var test = doc.data();
    return items;
  }

  // checkbox was tapped
  void checkBoxChanged(bool? newValue, TodoItem item) {
    setState(() {
      item.done = !item.done;
    });
    item.insertItem();
  }

  /// method to get the current name of the month and day
  String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('MMMM dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    void test() async {
      todayToDoList = await getItems();
      setState(() {});
    }

    test();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: const Text("TO DO"),
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.menu))
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // banner

              const SizedBox(height: 50),
              // text saying today and current date
              Text("Today, ${getCurrentDate()}"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(color: Theme.of(context).colorScheme.tertiary),
              ),

              Expanded(
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    itemCount: todayToDoList.length,
                    itemBuilder: (context, index) {
                      return ToDoTile(
                        item: todayToDoList[index],
                        onChanged: (value) =>
                            checkBoxChanged(value, todayToDoList[index]),
                        deleteFunction: (context) =>
                            deleteTask(todayToDoList[index], index),
                      );
                    },
                  ),
                ),
              ),

              // // list view for tommorow
              // const Text("Tommorow"),
              // Expanded(
              //   child: SizedBox(
              //     height: 200.0,
              //     child: ListView.builder(
              //       itemCount: tommorowToDoList.length,
              //       itemBuilder: (context, index) {
              //         return ToDoTile(
              //             item: tommorowToDoList[index],
              //             onChanged: (value) =>
              //                 checkBoxChanged(value, tommorowToDoList[index]));
              //       },
              //     ),
              //   ),
              // ),

              // // list view for the week
              // const Text("Week"),
              // Expanded(
              //   child: SizedBox(
              //     height: 200.0,
              //     child: ListView.builder(
              //       itemCount: weekToDoList.length,
              //       itemBuilder: (context, index) {
              //         return ToDoTile(
              //             item: weekToDoList[index],
              //             onChanged: (value) =>
              //                 checkBoxChanged(value, weekToDoList[index]));
              //       },
              //     ),
              //   ),
              // ),

              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.tertiary)),
                onPressed: () {
                  // item =
                  //     TodoItem(itemID: "test", itemName: "make notes for math");

                  // item.insertItem();
                  // setState(() {
                  //   todayToDoList.add(item);
                  // });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => IndividualPage()));
                },
                child: const Text('Add'),
              ),

              // add task button

              // view upcoming buttons
            ],
          ),
        ),
      ),
    );
  }
}
