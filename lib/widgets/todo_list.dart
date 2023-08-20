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
  bool a = false;
  List<TodoItem> positionlessItems = [];

  void positionItems() {
    // print("test ${widget.items.length}");

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

    // give each positionless item a position, and add it to the list
    positionlessItems.forEach((element) {
      element.position = widget.items.length;
      widget.items.add(element);
      element.updateItem();
      print(element.toMap());
    });

    // sort the list by posistion
    widget.items.sort((a, b) => a.position.compareTo(b.position));
  }

  @override
  void initState() {
    super.initState();
    print(widget.items);

    // // TODO: implement initState

    print(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    if (a == false && widget.items != []) {
      a = true;
      positionItems();
    }

    return Expanded(
      child: SizedBox(
        height: 200.0,
        child: ReorderableListView.builder(
          onReorder: (oldIndex, newIndex) {
            if (widget.whichday == WHICHDAY.TODAY) {
              ItemsProvider().changeOrderToday(oldIndex, newIndex);
            } else {
              ItemsProvider().changeOrderTomorrow(oldIndex, newIndex);
            }
            // widget.items[oldIndex].switchItem(widget.items[newIndex]);

            // setState(() {
            //   if (newIndex > oldIndex) newIndex--;

            //   // // store old Index Position
            //   // int tempPosition = widget.items[oldIndex].position;

            //   // // swap position of new and old index
            //   // widget.items[oldIndex].position = widget.items[newIndex].position;

            //   final item = widget.items.removeAt(oldIndex);
            //   widget.items.insert(newIndex, item);
            // });

            // for (int i = 0; i < widget.items.length; i++) {
            //   widget.items[i].position = i;
            //   widget.items[i].updateItem();
            // }
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
