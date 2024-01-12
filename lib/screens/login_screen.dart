import 'package:attendance/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors/colors.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  var iDController = TextEditingController();
  var passwordController = TextEditingController();
  late SharedPreferences sharedPreferences;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight / 2.5,
              width: screenWidth,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(70),
                ),
              ),
              child: Center(
                child: ImageIcon(
                  AssetImage("assets/images/logo.png"),
                  size: screenWidth * 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 15,
            ),
            Text(
              "Login",
              style: TextStyle(
                  fontSize: screenWidth / 18, fontFamily: 'Nexa Bold 650'),
            ),
            SizedBox(
              height: screenHeight / 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTitle("Employee ID"),
                  SizedBox(
                    height: screenHeight / 70,
                  ),
                  customFormField(
                      hintText: "Enter your ID",
                      iconData: Icons.person,
                      controller: iDController,
                      obscureText: false),
                  SizedBox(
                    height: screenHeight / 50,
                  ),
                  customTitle("Password"),
                  SizedBox(
                    height: screenHeight / 70,
                  ),
                  customFormField(
                      hintText: "Enter your password",
                      iconData: Icons.lock,
                      controller: passwordController,
                      obscureText: true),
                  SizedBox(
                    height: screenHeight / 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(screenWidth, screenHeight / 15),
                        backgroundColor: primary,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        String id = iDController.text.trim();
                        String password = passwordController.text;
                        if (id.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("ID Must Not Be Empty")));
                        } else if (password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Password Must Not Be Empty")));
                        } else {
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("Employee")
                              .where("id", isEqualTo: id)
                              .get();

                          try {
                            if (!context.mounted) return;
                            if (password == snap.docs[0]['password']) {
                              sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences
                                  .setString('employeeId', id)
                                  .then((_) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  HomeScreen.routeName,
                                );
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Password Not Correct")));
                            }
                          } catch (e) {
                            String error = '';
                            if (e.toString() ==
                                'RangeError (index): Invalid value: Valid value range is empty: 0') {
                              setState(() {
                                error = 'Employee ID Does Not Exist';
                              });
                            } else {
                              setState(() {
                                error = 'Error Occurred';
                              });
                            }
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(error)));
                          }
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: screenWidth / 15,
                          fontFamily: 'Nexa Bold 650',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: screenWidth / 26,
        fontFamily: 'Nexa Bold 650',
      ),
    );
  }

  Widget customFormField(
      {required String hintText,
      required IconData iconData,
      required TextEditingController controller,
      required bool obscureText}) {
    return Container(
      width: screenWidth,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(2, 2)),
          ]),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth / 6,
            child: Icon(
              iconData,
              color: primary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 12),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hintText,
                ),
                maxLines: 1,
                obscureText: obscureText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
