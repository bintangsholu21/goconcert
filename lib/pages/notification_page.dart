import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Text(
          'No notifications yet.',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
