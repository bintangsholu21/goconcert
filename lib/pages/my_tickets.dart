import 'package:flutter/material.dart';
import 'BottomNavBar.dart'; // Import the BottomNavBar file

class MyTicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tickets'),
      ),
      body: Center(
        child: Text('My Tickets Page Content'),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        currentPage: 2, // Set the correct current page index for BookmarkPage
        onPageChanged: (int page) {
          // Handle page changes if needed
        },
      ),
    );
  }
}
