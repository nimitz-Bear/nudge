import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/item.dart';
import '../screens/individual_page.dart';

class ToDoTile extends StatelessWidget {
  TodoItem item;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  ToDoTile(
      {super.key,
      required this.item,
      required this.onChanged,
      required this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    // return Slidable(
    //   endActionPane: ActionPane(
    //     motion: StretchMotion(),
    //     children: [
    //       SlidableAction(
    //           onPressed: deleteFunction,
    //           icon: Icons.delete,
    //           backgroundColor: Colors.red),
    //     ],
    //   ),
    // child:
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => IndividualPage(item: item))),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  item.deleteItem();
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          child: Container(
            // color: Theme.of(context).colorScheme.secondary,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // checkbox
                Checkbox.adaptive(
                  value: item.done,
                  onChanged: onChanged,
                  shape: const CircleBorder(),
                ),

                // task name
                Text(item.itemName,
                    style: TextStyle(
                        decoration: item.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none)),
              ],
            ),
            // ),
          ),
        ),
      ),
    );
  }
}
