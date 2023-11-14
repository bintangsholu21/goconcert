import 'package:flutter/material.dart';
import 'BottomNavBar.dart'; // Import the BottomNavBar file

class BookmarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmark'),
      ),
      body: Center(
        child: Text('Bookmark Page Content'),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        currentPage: 1, // Set the correct current page index for BookmarkPage
        onPageChanged: (int page) {
          // Handle page changes if needed
        },
      ),
    );
  }
}
