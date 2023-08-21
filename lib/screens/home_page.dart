import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/providers/items_provider.dart';
import 'package:nudge/screens/individual_page.dart';
import 'package:nudge/widgets/banner.dart';
import 'package:nudge/widgets/day_of_the_week.dart';
import 'package:provider/provider.dart';

import '../widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> selectedDay = [false, false, false, false, false, false, false];

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

  // checkbox was tapped
  void checkBoxChanged(bool? newValue, TodoItem item) {
    setState(() {
      item.done = !item.done;
    });
    item.updateItem();
  }

  /// method to get the current name of the month and day
  String getCurrentDate(DateTime date) {
    // var now = DateTime.now();
    var formatter = DateFormat('EEEE, MMMM dd');
    String formattedDate = formatter.format(date);
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ItemsProvider().getList(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
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

              Consumer<ItemsProvider>(
                builder: (context, provider, _) {
                  return TodoList(
                      items: provider.todayToDoList,
                      checkBoxChanged: checkBoxChanged,
                      deleteTask: deleteTask,
                      whichday: WHICHDAY.TODAY);
                },
              ),

              const Text("Tommorow"),

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
            ],
          ),
        ),
      ),
    );
  }
}
