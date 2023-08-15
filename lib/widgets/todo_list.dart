import 'package:flutter/material.dart';

import '../models/item.dart';
import 'todo_tile.dart';

class TodoList extends StatelessWidget {
  final List<TodoItem> items;
  final dynamic Function(bool?, TodoItem item) checkBoxChanged;
  final Function(List<TodoItem> items, int index) deleteTask;

  const TodoList(
      {super.key,
      required this.items,
      required this.checkBoxChanged,
      required this.deleteTask});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 200.0,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              item: items[index],
              onChanged: (value) => checkBoxChanged(value, items[index]),
              deleteFunction: (context) => deleteTask(items, index),
            );
          },
        ),
      ),
    );
  }
}
