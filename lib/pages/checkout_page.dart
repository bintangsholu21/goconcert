import 'package:flutter/material.dart';
import 'package:goconcert/pages/form_page.dart';
import 'package:goconcert/pages/paymentMethodPage.dart';
import 'package:goconcert/pages/payment_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutPage extends StatefulWidget {
  final String concertName;
  final String selectedPaymentMethod;
  final FormData formData;

  CheckoutPage(
      {required this.concertName,
      required this.selectedPaymentMethod,
      required this.formData});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  int selectedCat = 0;
  List<String> categoryNames = ['CAT 1', 'CAT 2', 'CAT 3'];
  List<String> prices = ['Rp2.000.000', 'Rp1.500.000', 'Rp1.200.000'];

  String selectedPaymentMethod = '';
  int? selectedCatTemp;

  void setSelectedPaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  void selectCat(int index) {
    if (selectedPaymentMethod.isEmpty) {
      setState(() {
        selectedCat = index;
        selectedCatTemp = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedCatTemp = selectedCat;
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
                            'Checkout Page',
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
            top: 170.0,
            left: 25.0,
            right: 25.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Ticket Type',
                  style: TextStyle(
                    color: Color(0xFF251F4F),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.0),
                ...List.generate(3, (index) {
                  String categoryName = categoryNames[index];
                  String price = prices[index];
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          selectCat(index);
                        },
                        tileColor: selectedCat == index
                            ? Color.fromARGB(255, 255, 255, 255)
                            : const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                            color: selectedCat == index
                                ? Color.fromARGB(255, 31, 27, 63)
                                : Color.fromARGB(255, 211, 211, 211),
                            width: 2,
                          ),
                        ),
                        title: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            categoryName,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: selectedCat == index
                                  ? Colors.black
                                  : Colors.black,
                            ),
                          ),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            price,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: selectedCat == index
                                  ? Colors.black
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0), // Add spacing of 30
                    ],
                  );
                }),
              ],
            ),
          ),
          Positioned(
            bottom:
                300.0, // Make this larger than the bottom property of the Positioned widget that displays the selected category
            left: 20.0,
            right: 20.0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NIK',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.formData.nik}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.formData.name}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.formData.address.split(' ').take(5).join(' ')}',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 230.0,
            left: 20.0,
            right: 20.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Category selected',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${categoryNames[selectedCat]}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Payment',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${prices[selectedCat]}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 190.0,
            left: 20.0,
            right: 20.0,
            child: Visibility(
              visible: widget.selectedPaymentMethod.isNotEmpty,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Payment Method',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.selectedPaymentMethod}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 120.0,
            left: 20.0,
            right: 20.0,
            child: Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentMethodPage(
                            concertName: widget.concertName,
                            formData: widget.formData)),
                  );
                },
                child: Text('Payment Methods'),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 14.0)
                      .copyWith(fontWeight: FontWeight.bold)
                      .copyWith(color: Colors.black)
                      .copyWith(fontFamily: 'Poppins'),
                  foregroundColor: Color.fromARGB(255, 31, 27, 63),
                  backgroundColor: Colors.white,
                  minimumSize: Size.fromHeight(50.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50.0,
            left: 20.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: () async {
                // Create a new document in Firestore
                // final payments = {
                //   'concertName': widget.concertName,
                //   'selectedCategory': categoryNames[selectedCat],
                //   'price': prices[selectedCat],
                //   'formData': {
                //     'nik': widget.formData.nik,
                //     'name': widget.formData.name,
                //     'address': widget.formData.address,
                //   },
                //   'paymentMethod': widget.selectedPaymentMethod,
                // };

                // await db.collection('payments').add(payments);

                // Navigate to the PaymentPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      selectedCat: categoryNames[
                          selectedCat], // Pass selected category name
                      price: prices[selectedCat],
                      formData: widget.formData,
                      paymentMethod: widget.selectedPaymentMethod,
                      concertName: widget.concertName,
                    ),
                  ),
                );
              },
              child: Text('Pay Now'),
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
        ],
      ),
    );
  }
}
