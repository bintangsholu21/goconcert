import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'BottomNavBar.dart'; // Import the BottomNavBar file
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;

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

  Future<void> processImage() async {
    // Read image from file
    img.Image? image = img.decodeImage(File(_image!.path).readAsBytesSync());

    if (image != null) {
      // Convert image to grayscale
      image = img.grayscale(image);

      // Increase contrast by 20%
      image = img.adjustColor(image, contrast: 50);

      image = img.adjustColor(image, brightness: 50);

      // Save the processed image
      File(_image!.path).writeAsBytesSync(img.encodeJpg(image));
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        processImage();
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
      _recognizedText = recognizedText.text;
      // _recognizedText = '\n$nik\n$name\n$birthDate\n$address';
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

  // String findNIK(String text) {
  //   final lines = text.split('\n');
  //   final nikKeyword = 'NIK';

  //   for (int i = 0; i < lines.length; i++) {
  //     if (lines[i].contains(nikKeyword)) {
  //       if (i + 2 < lines.length) {
  //         final nikLine = lines[i + 2];
  //         final nikValue = nikLine.substring(nikLine.indexOf(':') + 1).trim();
  //         if (isNumeric(nikValue) && nikValue.length == 16) {
  //           return 'NIK: $nikValue';
  //         }
  //       }
  //     }
  //   }

  //   return 'No NIK found';
  // }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  String findName(String text) {
    final lines = text.split('\n');
    final unwantedStrings = [
      'LAKI-LAKI',
      'PEREMPUAN',
      'DSN',
      'KELURAHAN',
      'KEL',
      'ISLAM',
      'KRISTEN',
      'KATOLIK',
      'HINDU',
      'BUDHA',
      'KONGHUCU',
      'BELUM KAWIN',
      'KAWIN',
      'PELAJAR/MAHASISWA',
      'PNS',
      'WNI',
      'SEUMUR HIDUP',
      'Nama',
      'Tempat/Tgl Lahir',
      'Alamat',
      'RT/RW',
      'Kel/Desa',
      'Kecamatan',
      'Agama',
      'Status Perkawinan',
      'Pekerjaan',
      'Kewarganegaraan',
      'Berlaku Hingga',
      'NIK'
    ];
    if (lines.length >= 14) {
      String name = lines.getRange(12, 13).join(' '); // Get lines 13 and 14
      for (var str in unwantedStrings) {
        name = name.replaceAll(str, '');
      }
      name = name.replaceAll(
          RegExp(r'\d{2}-\d{2}-\d{4}'), ''); // Remove date format
      name =
          name.replaceAll(RegExp(r'\d{3}/\d{3}'), ''); // Remove number format
      return 'Nama : $name';
    } else {
      return '';
    }
  }

  String findBirthDate(String text) {
    final RegExp regExp = RegExp(r'\b\d{2}-\d{2}-\d{4}\b');
    final Match? match = regExp.firstMatch(text);

    if (match != null) {
      final String birthDate = text.substring(match.start, match.end);
      final int year = int.parse(birthDate.split('-').last);
      if (year < 2011) {
        return 'Tanggal Lahir : $birthDate';
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  String findAddress(String text) {
    final lines = text.split('\n');
    if (lines.length >= 19) {
      String address = lines.getRange(16, 19).join(', '); // Get lines 17 to 19
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
