import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nudge/providers/labels_provider.dart';

import '../models/label.dart';
import 'label_page.dart';

class LabelPicker {
  Future<Label?> showLabelPicker(BuildContext context) {
    return showDialog<Label?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200,
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
                                        LabelsProvider()
                                            .deleteLabel(labels[index]);
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
                                    ],
                                  ),
                                  onDoubleTap: () => LabelPage().showLabelMaker(
                                      context,
                                      label: labels[index]),
                                ),
                                onTap: () =>
                                    Navigator.of(context).pop(labels[index]),
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
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      LabelPage().showLabelMaker(context);
                    },
                    child: const Row(
                      children: [Icon(Icons.add), Text("Add a label")],
                    ))
              ],
            ),
          );
        });
      },
    ).then((value) {
      return value;
    }).onError((error, stackTrace) {
      return null;
    });
  }
}
