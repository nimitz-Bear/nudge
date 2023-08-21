import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/providers/items_provider.dart';

import '../widgets/dialog_utils.dart';

class IndividualPage extends StatefulWidget {
  final TodoItem? item;

  const IndividualPage({super.key, this.item});

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  bool done = false;
  bool doNotification = false;
  DateTime now = DateTime.now();
  DateTime selectedDate = DateTime.now();
  var outputFormat = DateFormat('MMMM dd');
  var timeFormat = DateFormat.Hm();
  bool showTime = false;

  void onCheckboxChanged(bool? value) {
    setState(() {
      done = !done;
    });
  }

  // if there is an item passed in the constructor, set all the textFields with existing values
  void setupExistingItem() {
    TodoItem item;

    // don't do anything if there is no widget
    if (widget.item == null) {
      return;
    } else {
      item = widget.item!;
    }

    // string values
    titleController.text = item.itemName;
    descriptionController.text = item.itemDescription ?? "";
    locationController.text = item.location ?? "";
    linkController.text = item.link ?? "";

    // time
    selectedDate = item.time ?? DateTime.now();

    // bool
    done = item.done;
    doNotification = item.isReminder;

    //TODO: add ui elements for repeating and for labels
  }

  // save the fields values into an item
  void saveFields(TodoItem item) {
    item.itemName = titleController.text ?? "";
    item.itemDescription = descriptionController.text;
    item.location = locationController.text;
    item.link = linkController.text;
    item.time = selectedDate;
    item.isReminder = doNotification;
    item.done = done;
  }

  @override
  void initState() {
    setupExistingItem();
    selectedDate = DateTime(now.year, now.month, now.day);
    super.initState();
  }
  // TODO: refactor so that only the date/time picker is Stateful

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20),
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
                  const Icon(Icons.calendar_month_outlined),
                  TextButton(
                    onPressed: () async {
                      DateTime now = DateTime.now();

                      DateTime? test = await showDatePicker(
                          context: context,
                          initialDate: DateTime(now.year, now.month, now.day),
                          firstDate: now,
                          lastDate: DateTime(2101));

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

              showTime
                  ? Row(
                      children: [
                        const Icon(Icons.access_time_filled),
                        TextButton(
                            onPressed: () async {
                              TimeOfDay? chosenTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());

                              if (chosenTime != null) {
                                setState(() {
                                  selectedDate = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      chosenTime.hour,
                                      chosenTime.minute);
                                });
                              }
                            },
                            child: Text(timeFormat.format(selectedDate),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)))
                      ],
                    )
                  : OutlinedButton(
                      child: Text("Add time"),
                      onPressed: () => setState(() {
                            showTime = true;
                          })),
              Row(
                children: [
                  Icon(doNotification ? Icons.alarm : Icons.alarm_off),
                  const SizedBox(width: 10),
                  const Text("Remind Me"),
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
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 20),
                  decoration: const InputDecoration(
                      hintText: "Location ...", border: InputBorder.none)),
              TextFormField(
                  controller: linkController,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 20),
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
                    if (titleController.text.isEmpty) {
                      showErrorDialog(context, "Title of task can't be empty!");
                      return;
                    }

                    // TODO: move this to the ItemsProvider
                    // if the widget item doesnt exist, make a new one, else update
                    if (widget.item == null) {
                      TodoItem item = TodoItem(
                          itemID: "", itemName: titleController.text ?? "");

                      saveFields(item);

                      item.insertNewItem();
                      // ItemsProvider().getList(item.time ?? DateTime.now());
                    } else {
                      saveFields(widget.item!);

                      widget.item!.updateItem();
                      ItemsProvider().getList(DateTime.now());
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
