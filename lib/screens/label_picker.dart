import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nudge/providers/labels_provider.dart';

import '../models/label.dart';
import 'label_page.dart';

class LabelPicker extends StatefulWidget {
  final List<Label> existingLabels;
  const LabelPicker({super.key, required this.existingLabels});

  @override
  State<LabelPicker> createState() => _LabelPickerState();
}

class _LabelPickerState extends State<LabelPicker> {
  List<bool> picked = [];
  List<Label> chosenLabels = [];

  @override
  void initState() {
    // set the inital value fo the checkboxes
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      picked = List.filled((await LabelsProvider().getLabels()).length, false);
    });
    super.initState();
  }

  // remove duplicate Labels
  List<Label> fixChosenLabels(List<Label> input) {
    // add the existing labels to the chosenLabels list
    chosenLabels.addAll(widget.existingLabels);

    // remove all duplicates by converting to set and then back to list
    return input.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 250,
              height: 200,

              // get all the lsit of labels into a ListView using FutureBuilder
              child: FutureBuilder(
                future: LabelsProvider().getLabels(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Label> labels = snapshot.data ?? [];

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: labels.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  setState(() {
                                    LabelsProvider().deleteLabel(labels[index]);
                                  });
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                              )
                            ],
                          ),
                          child: ListTile(
                            title: GestureDetector(
                              child: Row(
                                children: [
                                  Icon(Icons.label_important,
                                      color: labels[index].color),
                                  const SizedBox(width: 10),
                                  Text(labels[index].name),
                                  const Expanded(child: SizedBox()),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Checkbox.adaptive(
                                        value: picked[index],
                                        onChanged: (value) {
                                          setState(() {
                                            picked[index] = !picked[index];
                                          });
                                          chosenLabels.add(labels[index]);
                                        }),
                                  )
                                ],
                              ),
                              onDoubleTap: () => LabelPage().showLabelMaker(
                                  context,
                                  label: labels[index]),
                            ),
                            // onTap: () => chosenLabels.add(labels[index]),
                          ),
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator.adaptive();
                  }
                },
              ),
              // ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      LabelPage().showLabelMaker(context);
                    },
                    child: const Row(
                      children: [Icon(Icons.add), Text("Add a label")],
                    )),
                const Expanded(child: SizedBox()),
                TextButton(
                    onPressed: () => Navigator.of(context)
                        .pop(fixChosenLabels(chosenLabels)),
                    child: const Text("Done")),
              ],
            ),
          ],
        ),
      );
    });
  }
}

Future<List<Label>?> showLabelPicker(BuildContext context) {
  return showDialog<List<Label>>(
    context: context,
    builder: (context) {
      return LabelPicker(existingLabels: []);
    },
  ).then((value) {
    return value;
  }).onError((error, stackTrace) {
    return null;
  });
}
// }
