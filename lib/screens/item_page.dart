import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nudge/models/item.dart';
import 'package:nudge/providers/items_provider.dart';
import 'package:nudge/providers/labels_provider.dart';
import 'package:nudge/screens/label_picker.dart';

import '../models/label.dart';
import '../widgets/dialog_utils.dart';

class ItemPage extends StatefulWidget {
  final TodoItem? item;

  const ItemPage({super.key, this.item});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
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
  List<Label> labels = [];

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

    // get the labels
    Future.delayed(Duration.zero, () async {
      labels = await LabelsProvider().getLabelsForItem(item);
      setState(() {});
    });

    //TODO: add ui elements for repeating
  }

  // save the fields values into an item
  void saveFields(TodoItem item) {
    item.itemName = titleController.text;
    item.itemDescription = descriptionController.text;
    item.location = locationController.text;
    item.link = linkController.text;
    item.time = selectedDate;
    item.isReminder = doNotification;
    item.done = done;
    item.labels = labels.map((e) => e.id).toList();
  }

  @override
  void initState() {
    // set selectedDate to start of the day
    selectedDate = DateTime(now.year, now.month, now.day);
    setupExistingItem();
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
            mainAxisSize: MainAxisSize.min,
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
                      // called when switch si toggled
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

              GestureDetector(
                onTap: () async {
                  Label? chosenLabel =
                      await LabelPicker().showLabelPicker(context);

                  if (chosenLabel != null) {
                    setState(() {
                      labels.add(chosenLabel);
                    });
                  }
                },
                child: FutureBuilder(
                  future: LabelsProvider().getLabelsForItem(widget.item),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.label),
                          SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width - 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: labels.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: labels[index].color,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(labels[index].name,
                                          style: const TextStyle(height: 1.1)),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator.adaptive();
                    }
                  },
                ),
              ),

              // TODO: Checklist (like a sub-list of tasks)

              const Expanded(child: SizedBox()),
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
                      TodoItem item =
                          TodoItem(itemID: "", itemName: titleController.text);

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
