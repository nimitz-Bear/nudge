import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserAuthentication {
  final FirebaseAuth firebaseAuth;

  UserAuthentication({required this.firebaseAuth});

  Stream<User?> get user => firebaseAuth.authStateChanges();

// TODO: check email validity using regex
  Future<String> passwordlessLogin(String email) async {
    var acs = ActionCodeSettings(
        // URL you want to redirect back to. The domain (www.example.com) for this
        // URL must be whitelisted in the Firebase Console.
        url: 'https://www.example.com/finishSignUp?cartId=1234',
        // This must be true
        handleCodeInApp: true,
        iOSBundleId: 'com.example.nudge',
        androidPackageName: 'com.example.nudge',
        // installIfNotAvailable
        androidInstallApp: true,
        // minimumVersion
        androidMinimumVersion: '12');

    // send users the email
    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));

    return "Signed in";
  }
}
