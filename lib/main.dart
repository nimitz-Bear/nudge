import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nudge/providers/items_provider.dart';
import 'package:nudge/screens/auth_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

const Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => ItemsProvider()))
        ],
        child: MaterialApp(
          theme: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFF3f6a85),
              selectionColor: Color(0xFF3f6a85),
              selectionHandleColor: Color(0xFF3f6a85),
            ),
            brightness: Brightness.light,
            primarySwatch: const MaterialColor(0xFF3f6a85, color),
            // fff9fe whiteish 60
            // fdb400 yellowish 30 (text)
            // 3f6a85 blue-grey 10 (titles, important buttons)

            colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: Colors.black,
                // secondaryContainer: Colors.white,
                onPrimary: Color(0xFFfdb400),
                secondary: Color(0xFFfdb400),
                onSecondary: Color(0xFFFFFFFF), // can also be whiteish
                tertiary: Color(0xFF3f6a85),
                onTertiary: Color(0xFFfdb400),
                error: Colors.black,
                onError: Colors.red,
                background: Color(0xFFfff9fe),
                onBackground: Color(0xFFfdb400),
                surface: Color(0xFFfff9fe),
                onSurface: Color(0xFF3f6a85)),

            // accent: const Color(0xFFFFA500),

            //text styling
            textTheme: const TextTheme(
              // titleMedium: TextStyle(fontSize: 32.0, color: Colors.pink),
              displayLarge: TextStyle(
                  fontSize: 72.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              displayMedium:
                  TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              displaySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
          ),
          debugShowCheckedModeBanner: false,
          // home: LoginPage(),
          home: AuthPage(),
          // home: HomePage(),
        ));
  }
}
