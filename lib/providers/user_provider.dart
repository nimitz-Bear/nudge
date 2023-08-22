import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/dialog_utils.dart';

class UserProvider extends ChangeNotifier {
  // make UserProvider a singleton
  static final UserProvider _singleton = UserProvider._internal();
  factory UserProvider() {
    return _singleton;
  }
  UserProvider._internal();

  // signs the current user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  /// signs the current user in with email and password
  void signUserIn(BuildContext context, String email, String password) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    // try to connect to firebase
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(title: Text(e.code));
          });
    }
  }

  // signs the current user in with google
  siginInWithGoogle() async {
    // begin interatcive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for the user
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    // use the new credential to sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // sign a user up using email and password
  void signUserUp(BuildContext context, String password, String confirmPassword,
      String email) async {
    //TODO: do some more verification of email and password

    // check if confirmed password is right
    if (password != confirmPassword) {
      showErrorDialog(context, "passwords don't match");
      return;
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      showErrorDialog(context, e.code);
      return;
    }
  }
}
