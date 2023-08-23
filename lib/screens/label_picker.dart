import 'package:flutter/material.dart';

import '../models/label.dart';

class LabelPicker {
  List<Label> labels = [
    Label("Work", Colors.blue),
    Label("Fun", Colors.greenAccent),
    Label("School", Colors.redAccent),
    Label("Errand", Colors.purple),
    // Label("Fun", Colors.greenAccent),
  ];

  Future<Label?> showLabelPicker(BuildContext context) {
    return showDialog<Label?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: 200,
            height: 200,

            child: ListView.builder(
              shrinkWrap: true,
              itemCount: labels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      const Icon(Icons.label_important),
                      const SizedBox(width: 10),
                      Text(labels[index].name),
                    ],
                  ),
                  onTap: () => Navigator.of(context).pop(labels[index]),
                );
              },
            ),
            // ),
          ),
        );
      },
    ).then((value) {
      return value;
    }).onError((error, stackTrace) {
      return null;
    });
  }
}

// import 'package:flutter/material.dart';

// class OptionDialog extends StatelessWidget {
//   final List<String> options;

//   OptionDialog({required this.options});

//   Future<String?> showOptionDialog(BuildContext context) async {
//     String? selectedOption;

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select an Option'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: options.map((option) {
//               return ListTile(
//                 title: Text(option),
//                 onTap: () {
//                   selectedOption = option;
//                   Navigator.pop(context);
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );

//     return selectedOption;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () async {
//         String? selected = await showOptionDialog(context);
//         if (selected != null) {
//           print('User selected: $selected');
//         }
//       },
//       child: Text('Show Option Dialog'),
//     );
//   }
// }

// // void main() {
// //   runApp(MaterialApp(
// //     home: Scaffold(
// //       appBar: AppBar(
// //         title: Text('Option Dialog Example'),
// //       ),
// //       body: Center(
// //         child: OptionDialog(options: ['Option 1', 'Option 2', 'Option 3']),
// //       ),
// //     ),
// //   ));
// // }
