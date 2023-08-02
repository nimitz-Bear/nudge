import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
          displayMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          displaySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      home: HomePage(),
    );
  }
}
