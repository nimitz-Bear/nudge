import 'package:flutter/material.dart';

import '../models/item.dart';
import 'todo_tile.dart';

class TodoList extends StatefulWidget {
  final List<TodoItem> items;
  final dynamic Function(bool?, TodoItem item) checkBoxChanged;
  final Function(List<TodoItem> items, int index) deleteTask;

  const TodoList(
      {super.key,
      required this.items,
      required this.checkBoxChanged,
      required this.deleteTask});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 200.0,
        child: ReorderableListView.builder(
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex--;

              final item = widget.items.removeAt(oldIndex);
              widget.items.insert(newIndex, item);
            });
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
