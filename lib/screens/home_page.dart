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
  List<TodoItem> todayToDoList = [
    TodoItem(
      itemID: "testID",
      itemName: "Make lunch",
    ),
  ];

  List<TodoItem> tommorowToDoList = [
    TodoItem(
      itemID: "testID",
      itemName: "Pack bags",
    ),
  ];

  List<TodoItem> weekToDoList = [
    TodoItem(
      itemID: "testID",
      itemName: "Get ready",
    ),
  ];

  // checkbox was tapped
  void checkBoxChanged(bool? newValue, TodoItem item) {
    setState(() {
      item.done = !item.done;
    });
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
    TodoItem item;
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
                              checkBoxChanged(value, todayToDoList[index]));
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
