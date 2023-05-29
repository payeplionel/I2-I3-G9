import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:i2_i3_g9/app/page_create_trip/view/create_trip.dart';
import 'package:i2_i3_g9/app/page_dogs_ride/view/dogs_ride.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/page_login/view/login.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dogs Trips',
      locale: const Locale('fr', 'FR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'), // French
        Locale('en', ''), // English
      ],
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(48, 51, 107, 1),
        primaryColorDark: const Color(0xFF1C2331),
        primaryColorLight: const Color.fromRGBO(48, 51, 107, 1),
      ),

      initialRoute: '/login',
      routes: {
        '/': (context) => DogsRide(),
        '/create': (context) =>  CreateTrip(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}

