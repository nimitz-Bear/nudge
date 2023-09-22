import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:nudge/providers/labels_provider.dart';
import 'package:nudge/screens/label_picker.dart';

import '../models/label.dart';

class LabelPage extends StatefulWidget {
  final Label? label;

  void showLabelMaker(BuildContext context, {Label? label}) {
    showDialog(context: context, builder: (context) => LabelPage(label: label));
  }

  const LabelPage({super.key, this.label});

  @override
  State<LabelPage> createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {
  Color dialogPickerColor =
      const Color(0xFFB00020); // Color for picker in dialog using onChanged

  TextEditingController labelName = TextEditingController();

  @override
  void initState() {
    // set the inital values, if label is not null
    if (widget.label != null) {
      labelName.text = widget.label!.name;
      dialogPickerColor = widget.label!.color;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: labelName,
                  decoration:
                      const InputDecoration(hintText: "Name your label"),
                )),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                dialogPickerColor =
                    await showColorPickerDialog(context, dialogPickerColor);

                setState(() {});
              },
              child: Row(
                children: [
                  const Icon(Icons.format_paint),
                  const SizedBox(width: 10),
                  const Text("Color"),
                  const Expanded(child: SizedBox()),
                  Container(
                    decoration: BoxDecoration(
                        color: dialogPickerColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: const SizedBox(height: 20, width: 20),
                  ),
                ],
              ),
            ),
            TextButton(
              child: const Text("Done"),
              onPressed: () async {
                // if using an existing label, update the values
                if (widget.label != null) {
                  widget.label?.name = labelName.text;
                  widget.label?.color = dialogPickerColor;
                }
                // upsert the label
                if (await LabelsProvider().upsertLabel(
                    context,
                    widget.label ??
                        Label("", labelName.text, dialogPickerColor))) {
                  Navigator.pop(context);
                  showLabelPicker(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
