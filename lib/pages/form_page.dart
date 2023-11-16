import 'package:flutter/material.dart';


class FormPage extends StatefulWidget {
  final String concertName;
  final String ocrResult;

  FormPage({required this.concertName, required this.ocrResult});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Parse the OCR result and set the initial values of the TextFormFields
    _nikController.text = findNIK(widget.ocrResult);
    _nameController.text = findName(widget.ocrResult);
    _birthDateController.text = findBirthDate(widget.ocrResult);
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
    if (lines.length >= 13) {
      String name =
          lines[12]; // Index 12 for the 13th line because index starts from 0
      name = name.replaceAll(':', '');
      return name;
    } else {
      return '';
    }
  }

  String findBirthDate(String text) {
    final RegExp regExp = RegExp(r'\b\d{1,2}-\d{1,2}-\d{2,4}\b');
    final Match? match = regExp.firstMatch(text);

    if (match != null) {
      final String birthDate = text.substring(match.start, match.end);
      return birthDate;
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
      return address;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form KTP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form for manual input
            TextFormField(
              controller: _nikController,
              decoration: InputDecoration(labelText: 'NIK'),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Lengkap'),
            ),
            TextFormField(
              controller: _birthDateController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),

            SizedBox(height: 20.0),

            // Button to submit the form
            ElevatedButton(
              onPressed: () {
                // Add logic to handle form submission
                // This could include validation and sending data to a server
                // For now, let's navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Submit Form'),
            ),
          ],
        ),
      ),
    );
  }
}
