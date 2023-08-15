import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayOfTheWeekWidget extends StatelessWidget {
  final DateTime date;
  final bool isHighlighted;

  const DayOfTheWeekWidget(
      {super.key, required this.date, this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
        fontSize: 20,
        color: isHighlighted
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.onSecondaryContainer);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => print("tapped ${DateFormat('dd').format(date)}"),
        child: Column(
          children: [
            Text(DateFormat('E').format(date)[0], style: style),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                  color: isHighlighted
                      ? Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withAlpha(150)
                      : Theme.of(context).colorScheme.tertiary.withAlpha(150),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  DateFormat('dd').format(date),
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
