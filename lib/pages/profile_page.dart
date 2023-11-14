import 'package:flutter/material.dart';
import 'BottomNavBar.dart'; // Import the BottomNavBar file

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('Profile Page Content'),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        currentPage: 3, // Set the correct current page index for BookmarkPage
        onPageChanged: (int page) {
          // Handle page changes if needed
        },
      ),
    );
  }
}
