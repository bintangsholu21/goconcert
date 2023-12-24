import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'BottomNavBar.dart'; // Import the BottomNavBar file
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool _isLoading = false;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _isLoading = true;
        uploadImage(_image!);
      } else {
        // Use a logging framework instead of print
        debugPrint('No image selected.');
      }
    });
  }

  void uploadImage(File imageFile) async {
    var url = Uri.parse('http://bintangsholu.pythonanywhere.com/upload');
    var request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      getOCRResult();
    }
  }

Future<void> getOCRResult() async {
  var url = Uri.parse('http://bintangsholu.pythonanywhere.com/display_results');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    print('Response body: ${response.body}');
    var decoded = jsonDecode(response.body);
    if (decoded is List && decoded.isNotEmpty) {
      var latestResult = decoded.last;
      if (latestResult.containsKey('NIK') && latestResult.containsKey('Nama') && latestResult.containsKey('Alamat')) {
        setState(() {
          _recognizedText = 'NIK: ${latestResult['NIK']}\nNama: ${latestResult['Nama']}\nAlamat: ${latestResult['Alamat']}';
          _isLoading = false;
        });
      } else {
        print('The keys "NIK", "Nama", and "Alamat" do not exist in the data.');
      }
    } else {
      print('No OCR results found.');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
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
                _isLoading
                    ? CircularProgressIndicator()
                    : _recognizedText.isEmpty
                        ? const Text('No NIK recognized.',
                            style: TextStyle(fontSize: 16))
                        : Column(
                            children: [
                              const Text('Hasil OCR',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
