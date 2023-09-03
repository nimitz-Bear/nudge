import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayOfTheWeekWidget extends StatefulWidget {
  final DateTime date;
  final bool isHighlighted;
  final int index;
  final Function(int) onUpdate;

  const DayOfTheWeekWidget(
      {super.key,
      required this.date,
      required this.onUpdate,
      this.isHighlighted = false,
      required this.index});
  // either index and onUpdate are both null or not null, since they are reliant one ach other

  @override
  State<DayOfTheWeekWidget> createState() => _DayOfTheWeekWidgetState();

  // void setIsHighlighted(bool value) {
  //   isHighlighted = value;
  // }
}

class _DayOfTheWeekWidgetState extends State<DayOfTheWeekWidget> {
  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
        fontSize: 20,
        color: widget.isHighlighted
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.onSecondaryContainer);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          print("tapped ${DateFormat('dd').format(widget.date)}");
          widget.onUpdate(widget.index);
        },
        child: Column(
          children: [
            Text(DateFormat('E').format(widget.date)[0], style: style),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                  color: widget.isHighlighted
                      ? Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withAlpha(150)
                      : Theme.of(context).colorScheme.tertiary.withAlpha(150),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  DateFormat('dd').format(widget.date),
                  style: style,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
