import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_that_table_flutter/views/welcome_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get That Table',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        appBarTheme: const AppBarTheme(
          color: Colors.blueAccent, // Set the background color of the app bar
          elevation: 4.0, // Set the elevation (shadow) of the app bar
          titleTextStyle: TextStyle(
              fontSize: 20.0, // Set the font size of the app bar title
              fontWeight: FontWeight.bold, // Set the font weight of the app bar title
            ),
          iconTheme: IconThemeData(
            color: Colors.white
          )
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(color: Colors.grey), // Set the border color
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(color: Colors.blueAccent), // Set the border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(color: Colors.blueAccent), // Set the focused border color
          ),
          labelStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold), // Set the label text color
          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold), // Set the hint text color
          fillColor: Color.fromARGB(255, 241, 242, 251), // Set the fill color of the TextField
          filled: true, // Set to true to fill the background of the TextField
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
