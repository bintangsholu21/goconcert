import 'package:flutter/material.dart';
import 'package:goconcert/pages/register_page.dart';
import 'dashboard.dart'; // Ganti dengan import sesuai struktur aplikasi Anda

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [const Color(0xFF0E0837), const Color(0xFF322C5D)],
              ),
            ),
          ),
          // Container 1
          Positioned(
            top: 80.0,
            left: 30.0,
            child: Container(
              child: Row(
                children: [
                  // Object 1 - Icon
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: Image(
                        image: AssetImage('assets/img/left-chevron.png'),
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Object 2 - Text
                  Text(
                    'Login', // Ubah teks menjadi 'Login'
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Form
          Positioned(
            top: 150.0, // Set the distance from the top
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
                      // Form Field - Email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                              controller: _emailController,
                              style: TextStyle(
                                  color: Colors
                                      .white), // This line changes the text color to white
                              decoration: InputDecoration(
                                fillColor: Color(0xFF363062),
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
                                hintText: 'Enter Email',
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(85, 255, 255, 255),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email cannot be empty';
                                } else if (!isValidEmail(value)) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
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
                              'Password',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                              controller: _passwordController,
                              style: TextStyle(
                                  color: Colors
                                      .white), // This line changes the text color to white
                              decoration: InputDecoration(
                                fillColor: Color(0xFF363062),
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
                                hintText: 'Enter Password',
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(85, 255, 255, 255),
                                ),
                                suffixIcon: IconButton(
                                  padding: EdgeInsets.only(right: 20.0),
                                  icon: Icon(
                                    _isPasswordHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordHidden = !_isPasswordHidden;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _isPasswordHidden,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password cannot be empty';
                                } else if (value.length < 8) {
                                  return 'Password at least 8 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Container 3
          Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Button - "Masuk" (Sebelumnya "Buat Akun")
                  Container(
                    width: 300.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DashboardWidget(), // Ganti dengan halaman tujuan setelah login
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF5E8C7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Login', // Ubah teks menjadi 'Masuk'
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Text - "Tidak memiliki akun? Daftar" (Sebelumnya "Sudah memiliki akun? Masuk")
                  GestureDetector(
                    onTap: () {
                      // Handle action when "Tidak memiliki akun? Daftar" text is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      'Do not have an account? Register', // Ubah teks
                      style: TextStyle(
                        color: Colors.white,
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

  bool isValidEmail(String email) {
    // Sesuaikan dengan logika validasi email yang Anda inginkan
    // Contoh sederhana:
    // Email harus mengandung @ dan setidaknya satu titik setelah @
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
