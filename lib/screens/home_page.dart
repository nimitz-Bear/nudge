import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/screens/individual_page.dart';
import 'package:nudge/widgets/banner.dart';
import 'package:nudge/widgets/day_of_the_week.dart';
import 'package:nudge/widgets/todo_tile.dart';

import '../widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> selectedDay = [false, false, false, false, false, false, false];
  List<TodoItem> todayToDoList = [];
  List<TodoItem> tommorowToDoList = [];

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void deleteTask(List<TodoItem> items, int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  dynamic onDayClicked(int index) {
    // set everything but hte clicked one to false
    for (var i = 0; i < selectedDay.length; i++) {
      if (i != index) {
        selectedDay[i] = false;
      }
    }

    if (selectedDay[index] != true) {
      // switch the bool values
      selectedDay[index] = !selectedDay[index];
    }
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

      items.forEach((element) {
        //   print(element.time!.isAtSameMomentAs(startOfDay));
        //   print(element.itemName);
        print(element.time);
        //   print(startOfDay);
        //   print(endOfDay);
      });
      List<TodoItem> itemsToRemove = [];

      // find all the indecides that are not relevant to today
      for (var element in items) {
        // print(element.time);
        if (element.time != null) {
          // if the time is not between the start and end of day, don't incldue it in the list
          if (!(element.time!.isAfter(startOfDay) &&
                  element.time!.isBefore(endOfDay)) &&
              !element.time!.isAtSameMomentAs(startOfDay)) {
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
  String getCurrentDate(DateTime date) {
    // var now = DateTime.now();
    var formatter = DateFormat('EEEE, MMMM dd');
    String formattedDate = formatter.format(date);
    return formattedDate;
  }

  // @override
  // void initState() {
  //   void test() async {
  //     tommorowToDoList =
  //         await getItemsForDay(DateTime.now().add(const Duration(days: 1)));
  //   }

  //   test();

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //TODO: change this to a StreamBuilder?
    void refreshItems() async {
      todayToDoList = await getItemsForDay(DateTime.now());
      tommorowToDoList =
          await getItemsForDay(DateTime.now().add(const Duration(days: 1)));

      if (this.mounted) setState(() {});
      // print(tommorowToDoList);
    }

    refreshItems();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: const Text("TO DO"),
        actions: [
          IconButton(
              onPressed: () => {signUserOut()}, icon: const Icon(Icons.logout))
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
                          child: Text(getCurrentDate(DateTime.now()),
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
                                    isHighlighted: selectedDay[index],
                                    onUpdate: (index) {
                                      onDayClicked(index);
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
                            deleteTask(todayToDoList, index),
                      );
                    },
                  ),
                ),
              ),

              // TODO: list view for tommorow
              const Text("Tommorow"),

              // TODO: because it's in the build function, refreshing the tommorow's item list
              // causes the drag reordering to be undone
              TodoList(
                  items: tommorowToDoList,
                  checkBoxChanged: checkBoxChanged,
                  deleteTask: deleteTask),

              // TOOD: list view for the week
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
