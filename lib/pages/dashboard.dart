import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat Datang di Dashboard',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            // Tambahkan widget atau fitur-fitur dashboard di sini
          ],
        ),
      ),
    );
  }
}
