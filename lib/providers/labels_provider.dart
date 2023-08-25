import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nudge/providers/user_provider.dart';
import 'package:nudge/widgets/dialog_utils.dart';

import '../models/label.dart';

// this class keeps a single static list of Labels for each User
class LabelsProvider extends ChangeNotifier {
  static final LabelsProvider _singleton = LabelsProvider._internal();
  factory LabelsProvider() {
    return _singleton;
  }
  LabelsProvider._internal();

  List<Label> _labels = [];
  List<Label> get labels => _labels;

  // gets the current user's labels
  Future<List<Label>> getLabels() async {
    String userId = UserProvider().getCurrentUserId() ?? "";

    // clear the list of labels
    _labels.clear();

    if (userId.isEmpty) {
      print(
          "Error: user id is null when gettign labels. Likely user is not logged in");
      return [];
      // TODO if no user logged in, print an error
    }

    // else check the user collection for the List of Labels
    final collection = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('labels')
        .get();

    for (var i in collection.docs) {
      _labels.add(Label.fromMap(i.data()));
    }

    for (var element in _labels) {
      print(element.toMap());
    }

    notifyListeners();
    return _labels;
  }

  Future<bool> upsertLabel(BuildContext context, Label label) async {
    if (await labelExistsByName(label)) {
      showErrorDialog(
          context, "Label with the name ${label.name} already exists.");
      return false;
    }

    if (label.id.isEmpty) {
      _newLabel(label);
    } else {
      _updateLabel(label);
    }
    notifyListeners();
    return true;
  }

  // returns true if the label exists
  Future<bool> labelExistsById(Label label) async {
    if (label.id.isEmpty) {
      return false;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(UserProvider().getCurrentUserId())
        .collection('labels')
        .doc(label.id);

    final result = await docRef.get();

    if (result.exists) {
      return true;
    }

    return false;
  }

  // check how many queries have a given name
  Future<bool> labelExistsByName(Label label) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserProvider().getCurrentUserId())
        .collection('labels')
        .where('labelName', isEqualTo: label.name)
        .get();

    if (query.size > 0) {
      return true;
    }

    return false;
  }

  void _newLabel(Label label) async {
    var id = FirebaseFirestore.instance.collection("items").doc().id;

    // set the label id with the Firebase auto generated id
    label.id = id;

    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(UserProvider().getCurrentUserId())
        .collection('labels')
        .doc(id);

    // create document
    await docRef.set(label.toMap());
  }

  void _updateLabel(Label label) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(UserProvider().getCurrentUserId())
        .collection('labels')
        .doc(label.id);

    // update document
    await docRef.update(label.toMap());
  }

  void deleteLabel(Label label) async {
    var ref = FirebaseFirestore.instance
        .collection('users')
        .doc(UserProvider().getCurrentUserId())
        .collection("labels")
        .doc(label.id);
    await ref.delete();

    notifyListeners();
  }
}
