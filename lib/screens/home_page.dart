import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/screens/individual_page.dart';
import 'package:nudge/widgets/banner.dart';
import 'package:nudge/widgets/day_of_the_week.dart';
import 'package:nudge/widgets/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> list2 = [false, false, false, false, false, false, false];
  List<TodoItem> todayToDoList = [];

  // represents the date that the user is looking at on the home page
  DateTime viewedDate = DateTime.now();

  void deleteTask(TodoItem item, int index) {
    setState(() {
      todayToDoList.removeAt(index);
    });
  }

  // get all the items from firebase, corresponding to the input date
  Future<List<TodoItem>> getItemsForDay(DateTime date) async {
    DateTime startOfDay =
        DateTime(date.year, date.month, date.day); // Set time to midnight
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59,
        59); // Set time to just before midnight

    List<TodoItem> items = [];

    await FirebaseFirestore.instance.collection("items").get().then((value) {
      List<Map<String, dynamic>> data = [];

      for (var i in value.docs) {
        data.add(i.data());
      }

      for (var element in data) {
        items.add(TodoItem.fromMap(element));
        // print(element);
      }

      List<TodoItem> itemsToRemove = [];

      // find all the indecides that are not relevant to today
      for (var element in items) {
        // print(element.time);
        if (element.time != null) {
          // if the time is not between the start and end of day, don't incldue it in the list
          if (!(element.time!.isAfter(startOfDay) &&
              element.time!.isBefore(endOfDay))) {
            itemsToRemove.add(element);
          }
        }
      }

      // remove all irrelevant elements
      for (var element in itemsToRemove) {
        items.remove(element);
      }
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
    var formatter = DateFormat('EEEE, MMMM dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    void refreshItems() async {
      todayToDoList = await getItemsForDay(DateTime.now());
      setState(() {});
    }

    refreshItems();

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
              ScreenBanner(
                  backgroundColor: Colors.pink,
                  backgroundImagePath: "assets/images/mountain_range.jpeg",
                  height: 200,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Text(getCurrentDate(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontSize: 30)),
                        ),
                        SizedBox(
                          height: 100,
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 7,
                              itemBuilder: (context, index) {
                                int inital = -3;
                                return DayOfTheWeekWidget(
                                    date: DateTime.now()
                                        .add(Duration(days: inital + index)),
                                    isHighlighted: list2[index],
                                    onUpdate: (index) {
                                      // print(index);

                                      // set everything but hte clicked one to false
                                      for (var i = 0; i < list2.length; i++) {
                                        if (i != index) {
                                          list2[i] = false;
                                        }
                                      }

                                      if (list2[index] != true) {
                                        // switch the bool values
                                        list2[index] = !list2[index];
                                      }
                                      // print(list2);

                                      //TODO: tell teh widget which index is clicked???
                                    },
                                    index: index);
                              },
                            ),
                          ),
                        ),
                      ])),
              const SizedBox(height: 20),
              // text saying today and current date
              const Text("Today"),
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

              // add task button
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.tertiary)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const IndividualPage()));
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataModel {
  String button;
  bool isSelected;

  DataModel(this.button, this.isSelected);
}
