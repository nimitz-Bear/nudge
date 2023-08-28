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

  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

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

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: dialogPickerColor,
      onColorChanged: (Color color) =>
          setState(() => dialogPickerColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
      colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      actionsPadding: const EdgeInsets.all(16),
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }
}
