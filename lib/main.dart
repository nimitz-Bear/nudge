// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.deepOrange,
//           title: const Text('Hello there'),
//         ),
//         body: const LoginWidget(),
//       ),
//     );
//   }
// }

// class LoginWidget extends StatefulWidget {
//   const LoginWidget({super.key});

//   @override
//   State<LoginWidget> createState() => _LoginWidgetState();
// }

// class _LoginWidgetState extends State<LoginWidget> {
//   TextEditingController emailController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           child: TextField(
//             controller: emailController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'email',
//             ),
//           ),
//         ),
//         Container(
//             height: 50,
//             padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//             child: ElevatedButton(
//               child: const Text('Continue with email'),
//               onPressed: () {
//                 print(emailController.text);
//               },
//             )),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xA1A9B3),
        highlightColor: const Color(0x494B42),
        canvasColor: Colors.white,
        primaryColorLight: const Color(0x99A598),
        fontFamily: 'Georgia',

        //text styling
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
          displayMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          displaySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
