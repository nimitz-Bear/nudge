import 'package:cloud_firestore/cloud_firestore.dart';
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

  void onCheckboxChanged(bool? value) {
    setState(() {
      done = !done;
    });
  }

  void setupExistingItem() {
    TodoItem item;

    // don't do anything if there is no widget
    if (widget.item == null) {
      return;
    } else {
      item = widget.item!;
    }

    // string values
    titleController?.text = item.itemName;
    descriptionController?.text = item.itemDescription ?? "";
    locationController?.text = item.location ?? "";
    linkController?.text = item.link ?? "";

    // time
    selectedDate =
        item.time ?? DateTime.now(); //TODO: figure out how to read in the time

    // bool
    done = item.done;
    doNotification = item.isReminder;

    //TODO: add ui elements for repeating and for labels
  }

  void saveFields(TodoItem item) {
    item.itemName = titleController?.text ?? "";
    item.itemDescription = descriptionController?.text;
    item.location = locationController?.text;
    item.link = linkController?.text;
    item.time = selectedDate;
    item.isReminder = doNotification;
    item.done = done;
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

  @override
  void initState() {
    setupExistingItem();
    super.initState();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row with:
              //  checkbox
              //   Title
              Row(
                children: [
                  Checkbox.adaptive(
                    value: done,
                    onChanged: onCheckboxChanged,
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
                        doNotification = !doNotification;
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
                    // if the widget item doesnt exist, make a new one, else update
                    if (widget.item == null) {
                      TodoItem item = TodoItem(
                          itemID: FirebaseFirestore.instance
                              .collection("items")
                              .doc()
                              .id,
                          itemName: titleController?.text ?? "");

                      saveFields(item);

                      item.insertItem();
                    } else {
                      saveFields(widget.item!);

                      widget.item!.updateItem();
                    }

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
