import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nudge/models/item.dart';

class IndividualPage extends StatefulWidget {
  final TodoItem? item;

  const IndividualPage({super.key, this.item});

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  TextEditingController? titleController = TextEditingController();
  TextEditingController? descriptionController = TextEditingController();
  TextEditingController? locationController = TextEditingController();
  TextEditingController? linkController = TextEditingController();

  bool done = false;
  bool doNotification = false;
  DateTime selectedDate = DateTime.now();
  var outputFormat = DateFormat('MMM dd HH:mm');

  String _date = "";
  void onChanged(bool? value) {
    setState(() {
      done = !done;
    });
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  // TODO: refactor so that only the date/time picker is Stateful

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: const Text("TO DO"),
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.menu))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Row with:
              //  checkbox
              //   Title
              Row(
                children: [
                  Checkbox.adaptive(
                    value: done,
                    onChanged: onChanged,
                    shape: const CircleBorder(),
                  ),
                  Title(
                      color: Theme.of(context).colorScheme.tertiary,
                      child: Expanded(
                        child: TextFormField(
                          // initialValue: "Rebuild all of Discord from scratch",
                          decoration: const InputDecoration(
                              labelText: "Name",
                              hintText: "Title",
                              border: InputBorder.none),
                          controller: titleController,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: null,
                        ),
                      ))
                ],
              ),

              Divider(color: Theme.of(context).colorScheme.tertiary),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(Icons.description),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Description ...",
                          border: InputBorder.none),
                      controller: descriptionController,
                      maxLines: null,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  const Icon(Icons.access_time_outlined),
                  TextButton(
                    onPressed: () async {
                      DateTime? test =
                          await showDateTimePicker(context: context);

                      setState(() {
                        if (test != null) selectedDate = test;
                      });
                    },
                    child: Text(outputFormat.format(selectedDate),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary)),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.alarm),
                  const SizedBox(width: 10),
                  const Text("Notification"),
                  Switch(
                    // This bool value toggles the switch.
                    value: doNotification,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        doNotification = value;
                        // widget.onValueChanged(value);
                      });
                    },
                  ),
                ],
              ),

              // Date: today
              // Labels:
              // Quick Actions: reminder, move

              TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                      hintText: "Location ...", border: InputBorder.none)),
              TextFormField(
                  controller: linkController,
                  decoration: const InputDecoration(
                      hintText: "Link ...", border: InputBorder.none)),
              Divider(color: Theme.of(context).colorScheme.tertiary),
              const SizedBox(
                  height: 50, child: Center(child: Text("Do Labels here"))),
              // TODO: a list of labels and a + button
              // TODO: Checklist

              const Expanded(
                child: SizedBox(),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  child: const Text("Save"),
                  onPressed: () {
                    TodoItem item = TodoItem(
                        itemID: FirebaseFirestore.instance
                            .collection("items")
                            .doc()
                            .id,
                        itemName: titleController?.text ?? "",
                        itemDescription: descriptionController?.text,
                        location: locationController?.text,
                        link: linkController?.text,
                        time: selectedDate);

                    item.insertItem();

                    const AlertDialog(title: Text("Saved reminder"));
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
