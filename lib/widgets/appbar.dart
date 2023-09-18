import 'package:flutter/material.dart';

import '../providers/user_provider.dart';
import '../screens/calendar_page.dart';
import '../screens/home_page.dart';
import '../screens/item_page.dart';

class MyAppBar extends StatelessWidget {
  final bool showAddButton;

  const MyAppBar({
    super.key,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage())),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CalendarPage())),
          ),
          showAddButton
              ? FloatingActionButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ItemPage())),
                  child: const Icon(Icons.add),
                )
              : const SizedBox(),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          IconButton(
            icon: const Icon(Icons.stacked_line_chart_outlined),
            onPressed: () {
              // Handle favorite button press
            },
          ),
          IconButton(
              onPressed: () => UserProvider().signUserOut(),
              icon: const Icon(Icons.logout)),
        ],
      ),
    );
  }
}
