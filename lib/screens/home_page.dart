import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/providers/items_provider.dart';
import 'package:nudge/screens/individual_page.dart';
import 'package:nudge/widgets/banner.dart';
import 'package:nudge/widgets/day_of_the_week.dart';
import 'package:nudge/widgets/todo_tile.dart';
import 'package:provider/provider.dart';

import '../widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> selectedDay = [false, false, false, false, false, false, false];
  // List<TodoItem> todayToDoList = [];
  // List<TodoItem> tommorowToDoList = [];

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

  // List<TodoItem> todoItems = [];
  // // get all the items from firebase, corresponding to the input date
  // Future<List<TodoItem>> getItemsForDay(DateTime date) async {
  //   DateTime startOfDay =
  //       DateTime(date.year, date.month, date.day); // Set time to midnight
  //   DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59,
  //       59); // Set time to just before midnight
  //   todoItems.clear();
  //   // List<TodoItem> items = [];

  //   await FirebaseFirestore.instance
  //       .collection("items")
  //       .where('time',
  //           isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
  //       .where('time', isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch)
  //       .get()
  //       .then((value) {
  //     List<Map<String, dynamic>> data = [];

  //     for (var i in value.docs) {
  //       data.add(i.data());
  //     }

  //     for (var element in data) {
  //       todoItems.add(TodoItem.fromMap(element));
  //     }
  //   });

  //   return todoItems;
  // }

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

  //TODO: change this to a StreamBuilder?
  // Future<List<TodoItem>> refreshItems() async {
  //     ItemsProvider().getList(DateTime.now());
  //   tommorowToDoList =
  //       await getItemsForDay(DateTime.now().add(const Duration(days: 1)));

  //   if (mounted) setState(() {});
  //   return tommorowToDoList;
  //   // print(tommorowToDoList);
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ItemsProvider().getList(DateTime.now());
      // refreshItems();
      // print("t ${tommorowToDoList.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    // refreshItems();

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Handle home button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () {
                // Handle search button press
              },
            ),
            FloatingActionButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const IndividualPage())),
              child: const Icon(Icons.add),
            ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            IconButton(
              icon: const Icon(Icons.stacked_line_chart_outlined),
              onPressed: () {
                // Handle favorite button press
              },
            ),
            IconButton(
                onPressed: () => signUserOut(), icon: const Icon(Icons.logout)),
          ],
        ),
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
                  child: Consumer<ItemsProvider>(
                    builder: (context, provider, _) {
                      return ListView.builder(
                        itemCount: provider.todayToDoList.length,
                        itemBuilder: (context, index) {
                          return ToDoTile(
                            item: provider.todayToDoList[index],
                            onChanged: (value) => checkBoxChanged(
                                value, provider.todayToDoList[index]),
                            deleteFunction: (context) =>
                                deleteTask(provider.todayToDoList, index),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              const Text("Tommorow"),
              // TODO: because it's in the build function, refreshing the tommorow's item list
              // causes the drag reordering to be undone

              Consumer<ItemsProvider>(
                builder: (context, provider, _) {
                  return TodoList(
                    items: provider.tommorowToDoList,
                    checkBoxChanged: checkBoxChanged,
                    deleteTask: deleteTask,
                    whichday: WHICHDAY.TOMORROW,
                  );
                },
              ),

              // TODO: list view for the week?
            ],
          ),
        ),
      ),
    );
  }
}
