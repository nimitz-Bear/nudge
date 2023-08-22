import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nudge/providers/items_provider.dart';
import 'package:nudge/screens/auth_page.dart';
import 'package:nudge/themes/default_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => ItemsProvider()))
        ],
        child: MaterialApp(
          theme: defaultTheme,
          debugShowCheckedModeBanner: false,
          home: const AuthPage(),
        ));
  }
}
