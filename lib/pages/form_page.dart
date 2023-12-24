import 'package:flutter/material.dart';
import 'package:goconcert/pages/checkout_page.dart';

class FormPage extends StatefulWidget {
  final String concertName;
  final String ocrResult;

  FormPage({required this.concertName, required this.ocrResult});

  @override
  _FormPageState createState() => _FormPageState();
}

class FormData {
  final String nik;
  final String name;
  final String address;

  FormData({required this.nik, required this.name, required this.address});
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nikController;
  late TextEditingController _nameController;
  late TextEditingController _addressController;

@override
void initState() {
  super.initState();
  // Parse ocrResult
  Map<String, String> ocrData = {};
  List<String> lines = widget.ocrResult.split('\n');
  for (var line in lines) {
    List<String> parts = line.split(': ');
    if (parts.length == 2) {
      ocrData[parts[0]] = parts[1];
    }
  }
  _nikController = TextEditingController(text: ocrData['NIK']);
  _nameController = TextEditingController(text: ocrData['Nama']);
  _addressController = TextEditingController(text: ocrData['Alamat']);
}


  @override
  void dispose() {
    _nikController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              // Container 2 - Header
              height: 130.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
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
                            'Form Page',
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
          ),
          Positioned(
            top: 120.0, // Set the distance from the top
            left: 0,
            right: 0,
            child: Center(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(35.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Form Field - Nama
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              'NIK',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(
                                      -3, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _nikController,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                hintText: 'NIK Anda',
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(85, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      // Form Field - Email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Full Name',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(
                                      -3, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              style: TextStyle(
                                  color: Colors
                                      .black), // This line changes the text color to white
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                hintText: 'Your Full Name',
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(85, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      // Form Field - Kata Sandi
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Address',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(
                                      -3, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _addressController,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                hintText: 'Your Address (5 words only)',
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(85, 255, 255, 255),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50.0,
            left: 20.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: () {
                FormData formData = FormData(
                  nik: _nikController.text,
                  name: _nameController.text,
                  address: _addressController.text,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPage(
                      concertName: widget.concertName,
                      selectedPaymentMethod: '',
                      formData: formData, // Pass formData to CheckoutPage
                    ),
                  ),
                );
              },
              child: Text('Submit Form'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF363062),
                minimumSize: Size.fromHeight(60.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadowColor: Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
            ),
          ),
          // Button to submit the form
        ],
      ),
    );
  }
}
