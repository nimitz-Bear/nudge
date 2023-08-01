import 'package:flutter/material.dart';

import '../models/item.dart';

class ToDoTile extends StatelessWidget {
  TodoItem item;
  Function(bool?)? onChanged;

  ToDoTile({super.key, required this.item, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
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
      ),
    );
  }
}
