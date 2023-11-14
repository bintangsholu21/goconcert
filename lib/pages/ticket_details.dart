import 'package:flutter/material.dart';

class TicketDetails extends StatelessWidget {
  final String concertName;

  TicketDetails({required this.concertName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
      ),
      body: Center(
        child: Text('Details for $concertName'),
      ),
    );
  }
}
