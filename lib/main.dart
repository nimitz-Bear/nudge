import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';

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
        // fff9fe whiteish 60
        // fdb400 yellowish 30 (text)
        // 3f6a85 blue-grey 10 (titles, important buttons)

        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFFfff9fe),
            onPrimary: Color(0xFFfdb400),
            secondary: Color(0xFFfdb400),
            onSecondary: Color(0xFF3f6a85), // can also be whiteish
            tertiary: Color(0xFF3f6a85),
            onTertiary: Color(0xFFfdb400),
            error: Colors.black,
            onError: Colors.white,
            background: Color(0xFFfff9fe),
            onBackground: Color(0xFFfdb400),
            surface: Colors.black,
            onSurface: Colors.white),

        // accent: const Color(0xFFFFA500),

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
