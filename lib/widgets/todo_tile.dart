import 'package:flutter/material.dart';

import '../models/item.dart';

class ToDoTile extends StatelessWidget {
  TodoItem item;
  Function(bool?)? onChanged;

  ToDoTile({super.key, required this.item, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
    );
  }
}
