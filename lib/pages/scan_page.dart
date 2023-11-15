import 'package:flutter/material.dart';

class ScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Ticket'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code,
              size: 100.0,
              color: Colors.blue,
            ),
            SizedBox(height: 20.0),
            Text(
              'Arahkan kamera Anda ke QR Code tiket',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle scan button tap
                // You can implement QR code scanning logic here
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF251F4F),
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Scan Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
