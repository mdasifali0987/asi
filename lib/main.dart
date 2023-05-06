import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sawari/register_page/register_screen.dart';
import 'package:sawari/splash_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.green.shade700,
          secondary: Colors.green.shade700,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
