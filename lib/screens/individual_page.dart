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
  DateTime selectedDate = DateTime.now();
  var outputFormat = DateFormat('MMM dd HH:mm');

  void onChanged(bool? value) {
    setState(() {
      done = !done;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }

    if (context.mounted) {
      showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
    }
  }

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
                              hintText: "Title", border: InputBorder.none),
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
                    onPressed: () => _selectDate(context),
                    child: Text(outputFormat.format(selectedDate),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary)),
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
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  child: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.secondary),
                  onPressed: () {
                    TodoItem item = TodoItem(
                        itemID: "test",
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
