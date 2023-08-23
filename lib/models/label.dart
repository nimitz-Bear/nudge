import 'package:flutter/material.dart';

class Label {
  String name = "";
  Color color = const Color(0xFF3498db);

  Label(this.name, this.color);

  Map<String, dynamic> toMap() {
    return {
      'labelName': name,
      'color': color.value,
    };
  }

  static Label fromMap(Map<String, dynamic> map) {
    return Label(map['labelName'], map['color']);
  }
}
