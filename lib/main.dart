import 'package:flutter/material.dart';
import 'package:goconcert/pages/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goconcert/pages/my_tickets.dart';
import 'package:goconcert/pages/start_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoConcert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartApp(),
    );
  }
}
