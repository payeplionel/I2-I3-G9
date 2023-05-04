import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/view/dogs_ride.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(48, 51, 107, 1),
        primaryColorDark: const Color(0xFF1C2331),
        primaryColorLight: const Color.fromRGBO(48, 51, 107, 1),
      ),
      home: const DogsRide(),
    );
  }
}

