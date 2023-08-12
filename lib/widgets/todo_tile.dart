import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/item.dart';

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
      padding: EdgeInsets.all(8),
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
    );
  }
}
