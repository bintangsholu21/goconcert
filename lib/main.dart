import 'package:flutter/material.dart';
import 'package:goconcert/pages/dashboard.dart';
import 'package:goconcert/pages/start_app.dart';
import 'package:goconcert/pages/ticket_details.dart';

void main() {
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
      home: DashboardWidget(),
    );
  }
}
