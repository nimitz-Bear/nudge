import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:nudge/providers/items_provider.dart';

import '../models/item.dart';
import '../screens/individual_page.dart';

class ToDoTile extends StatefulWidget {
  final TodoItem item;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  const ToDoTile(
      {super.key,
      required this.item,
      required this.onChanged,
      required this.deleteFunction});

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.item.itemName;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onDoubleTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => IndividualPage(item: widget.item))),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  widget.item.deleteItem();

                  // update the provider to show the item as deleted
                  ItemsProvider()
                      .getItemsForDay(widget.item.time ?? DateTime.now());
                  setState(() {});
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // checkbox
                Checkbox.adaptive(
                  value: widget.item.done,
                  onChanged: widget.onChanged,
                  shape: const CircleBorder(),
                ),

                // task name
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 30,
                      child: TextFormField(
                        onFieldSubmitted: (value) {
                          widget.item.itemName = titleController.text;
                          widget.item.updateItem();
                        },
                        controller: titleController,
                        maxLength: 30,
                        decoration: const InputDecoration(
                            border: InputBorder.none, counterText: ''),
                      ),
                    ),
                    Text(
                        DateFormat('MMM d HH:mm', 'en_US').format(
                          widget.item.time ??
                              DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day),
                        ),
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                            decoration: widget.item.done
                                ? TextDecoration.lineThrough
                                : TextDecoration.none)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
