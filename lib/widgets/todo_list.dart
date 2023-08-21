import 'package:flutter/material.dart';
import 'package:nudge/providers/items_provider.dart';

import '../models/item.dart';
import 'todo_tile.dart';

enum WHICHDAY { TODAY, TOMORROW }

class TodoList extends StatefulWidget {
  final List<TodoItem> items;
  final dynamic Function(bool?, TodoItem item) checkBoxChanged;
  final Function(List<TodoItem> items, int index) deleteTask;
  final WHICHDAY whichday;

  const TodoList({
    super.key,
    required this.items,
    required this.checkBoxChanged,
    required this.deleteTask,
    required this.whichday,
  });

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool itemsSorted = false;
  List<TodoItem> positionlessItems = [];

  void positionItems() {
    print("test ${widget.items.length}");

    // look for the posistionless items
    widget.items.forEach((element) {
      print("test");
      if (element.position == -1) {
        positionlessItems.add(element);
      }
    });

    // remove posistionless items from the list
    for (var element in positionlessItems) {
      widget.items.remove(element);
    }

    // give each positionless item a position, at the end and add it to the list
    positionlessItems.forEach((element) {
      element.position = widget.items.length;
      widget.items.add(element);
      print("new pos ${element.position}");
      element.updateItem();
      print(element.toMap());
    });

    // finally, sort the list by posistion
    widget.items.sort((a, b) => a.position.compareTo(b.position));
  }

  @override
  void initState() {
    super.initState();

    itemsSorted = false;
    print("inital ${widget.items.length}");
  }

  @override
  Widget build(BuildContext context) {
    if (itemsSorted == false && widget.items.isNotEmpty) {
      print("sorted items");
      itemsSorted = true;
      positionItems();
    }

    return Expanded(
      child: SizedBox(
        height: 200.0,
        child: ReorderableListView.builder(
          onReorder: (oldIndex, newIndex) {
            // print("test");
            if (widget.whichday == WHICHDAY.TODAY) {
              ItemsProvider().changeOrderToday(oldIndex, newIndex);
            } else {
              ItemsProvider().changeOrderTomorrow(oldIndex, newIndex);
            }

            // widget.items.forEach((element) {
            //   print(element.toMap());
            // });
            // positionItems();
          },
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              key: ValueKey(widget.items[index].itemID),
              item: widget.items[index],
              onChanged: (value) =>
                  widget.checkBoxChanged(value, widget.items[index]),
              deleteFunction: (context) =>
                  widget.deleteTask(widget.items, index),
            );
          },
        ),
      ),
    );
  }
}
