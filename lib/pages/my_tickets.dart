import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'BottomNavBar.dart'; // Import the BottomNavBar file
import 'package:google_ml_kit/google_ml_kit.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({Key? key}) : super(key: key);

  @override
  _MyTicketsPageState createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  File? _image;
  final picker = ImagePicker();
  final _textController = TextEditingController();
  String _recognizedText = '';

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        recognizeText();
      } else {
        // Use a logging framework instead of print
        debugPrint('No image selected.');
      }
    });
  }

  Future<void> recognizeText() async {
    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    final String nik = findNIK(recognizedText.text);
    final String name = findName(recognizedText.text);
    final String birthDate = findBirthDate(recognizedText.text);
    final String address = findAddress(recognizedText.text);

    setState(() {
      // _recognizedText = recognizedText.text;
      _recognizedText = '\n$nik\n$name\n$birthDate\n$address';
    });
  }

  String findNIK(String text) {
    final RegExp regExp = RegExp(r'\b\d{16}\b');
    final Match? match = regExp.firstMatch(text);

    if (match != null) {
      final String nik = text.substring(match.start, match.end);
      return 'NIK: $nik';
    } else {
      return 'No NIK found';
    }
  }

  String findName(String text) {
    final lines = text.split('\n');
    if (lines.length >= 13) {
      final String name =
          lines[12]; // Index 12 for the 13th line because index starts from 0
      return 'Nama : $name';
    } else {
      return 'No Name found';
    }
  }

  String findBirthDate(String text) {
    final RegExp regExp = RegExp(r'\b\d{1,2}-\d{1,2}-\d{2,4}\b');
    final Match? match = regExp.firstMatch(text);

    if (match != null) {
      final String birthDate = text.substring(match.start, match.end);
      return 'Tanggal Lahir : $birthDate';
    } else {
      return '';
    }
  }

  String findAddress(String text) {
    final lines = text.split('\n');
    if (lines.length >= 20) {
      String address = lines
          .getRange(15, 19)
          .join(', '); // Join lines with a comma and a space
      address = address.replaceAll(':', '');
      return 'Alamat : $address';
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tickets'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                _image == null
                    ? const Text('No image selected.')
                    : Image.file(_image!),
                const SizedBox(height: 20),
                _recognizedText.isEmpty
                    ? const Text('No NIK recognized.',
                        style: TextStyle(fontSize: 16))
                    : Column(
                        children: [
                          const Text('Hasil OCR',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(_recognizedText,
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                ElevatedButton(
                  onPressed: getImage,
                  child: const Text('Upload Image'),
                ),
              ],
            ),
          ),
        ),
        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavBar(
          currentPage: 2, // Set the correct current page index for BookmarkPage
          onPageChanged: (int page) {
            // Handle page changes if needed
          },
        ),
      ),
    );
  }
}
