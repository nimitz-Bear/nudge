import 'package:flutter/material.dart';

class Label {
  String label = "";
  String name = "";
  String id = "";
  Color color = const Color(0xFF3498db);

  Label(this.id, this.name, this.color);

  Map<String, dynamic> toMap() {
    return {
      'labelId': id,
      'labelName': name,
      'color': color.value,
    };
  }

  static Label fromMap(Map<String, dynamic> map) {
    return Label(map['labelId'], map['labelName'], Color(map['color']));
  }
}
