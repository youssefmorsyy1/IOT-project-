import 'package:flutter/material.dart';
import 'package:project2/services/air_quality.dart';
import 'package:project2/firebase/sign_up.dart';
import 'package:project2/firebase/sign_in.dart';
import 'package:project2/home.dart';
import 'package:project2/services/writing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Air Quality Monitor',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set the background color
      ),
      home: const HomePage(), // Set the home page to HomePage
      routes: {
        '/home': (context) => const HomePage(),
        '/sign_up': (context) => const sign_up(),
        '/sign_in': (context) => sign_in(),
        '/air_quality': (context) => const air_quality(),
        '/writing': (context) => devices_control(),
      },
    );
  }
}
