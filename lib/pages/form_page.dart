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
  final _nikController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Parse the OCR result and set the initial values of the TextFormFields
    _nikController.text = findNIK(widget.ocrResult);
    _nameController.text = findName(widget.ocrResult);
    _addressController.text = findAddress(widget.ocrResult);
  }

  String findNIK(String text) {
    final RegExp regExp = RegExp(r'\b\d{16}\b');
    final Match? match = regExp.firstMatch(text);

    if (match != null) {
      final String nik = text.substring(match.start, match.end);
      return nik;
    } else {
      return '';
    }
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
      'NIK',
      'PROVINSI', // Add unwanted string
      'KOTA', // Add unwanted string
      'KABUPATEN' // Add unwanted string
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
      return name;
    } else {
      return '';
    }
  }

  String findAddress(String text) {
    final lines = text.split('\n');
    if (lines.length >= 20) {
      String address = lines
          .getRange(15, 18)
          .join(', '); // Join lines with a comma and a space
      address = address.replaceAll(':', '');
      return address;
    } else {
      return '';
    }
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
                              'Nama Lengkap',
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
                                hintText: 'Nama Lengkap Anda',
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
                                hintText: 'Address Anda (5 words only)',
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
