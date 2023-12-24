import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:camera/camera.dart';
import 'form_page.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ScanPage extends StatefulWidget {
  final String concertName;

  ScanPage({required this.concertName});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  // Add this to your state variables
  bool _isLoading = false;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  File? _image;
  final picker = ImagePicker();
  final _textController = TextEditingController();
  String _recognizedText = '';

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

  Future<void> uploadImage(File image) async {
    var url = Uri.parse('http://bintangsholu.pythonanywhere.com/upload');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully.');
    } else {
      print('Image upload failed with status: ${response.statusCode}.');
    }
  }

  Future<String> getOCRResult() async {
    var url =
        Uri.parse('http://bintangsholu.pythonanywhere.com/display_results');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      var decoded = jsonDecode(response.body);
      if (decoded is List && decoded.isNotEmpty) {
        var latestResult = decoded.last;
        if (latestResult.containsKey('NIK') &&
            latestResult.containsKey('Nama') &&
            latestResult.containsKey('Alamat')) {
          return 'NIK: ${latestResult['NIK']}\nNama: ${latestResult['Nama']}\nAlamat: ${latestResult['Alamat']}';
        } else {
          print(
              'The keys "NIK", "Nama", and "Alamat" do not exist in the data.');
          return 'Error: The keys "NIK", "Nama", and "Alamat" do not exist in the data.';
        }
      } else {
        print('No OCR results found.');
        return 'Error: No OCR results found.';
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return 'Error: Request failed with status: ${response.statusCode}.';
    }
  }

  Future<String> recognizeText() async {
    await uploadImage(_image!);
    return await getOCRResult();
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      _controller?.startImageStream((image) => null); // Start the camera stream
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isLoading
            ? Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3), // Transparent background
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
          // Container 1 - Camera Preview
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 600,
              width: 450,
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Make sure _controller is initialized before using it
                    return _controller != null
                        ? AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: CameraPreview(_controller!),
                          )
                        : Container();
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),

          Container(
            // Container 2 - Header
            height: 130.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              margin: EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          'Scan KTP',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Container 3 - Align Bottom Center
          Positioned(
            bottom: 45.0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;

                        final image = await _controller?.takePicture();

                        // Process the image with text recognition
                        _image = File(image!.path);
                        final recognizedText = await recognizeText();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormPage(
                              concertName: widget.concertName,
                              ocrResult: recognizedText,
                            ),
                          ),
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: CircleBorder(),
                      side: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Icon(
                        FontAwesomeIcons.camera,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'Or',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Container(
                    width: 370.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await getImage();
                        final recognizedText = await recognizeText();
                        setState(() {
                          _isLoading = false;
                        });
                        if (!_isLoading) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormPage(
                                concertName: widget.concertName,
                                ocrResult: recognizedText,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Upload KTP',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          fontFamily: 'Poppins ',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
