import 'package:attendance/colors/colors.dart';
import 'package:attendance/models/user_model.dart';
import 'package:attendance/screens/widegts/defukt_form_field.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: screenHeight / 8, bottom: screenHeight / 70),
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  color: primary, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: screenWidth / 5,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Employee ${User.employeeID}",
                style: TextStyle(
                    fontSize: screenWidth / 23, fontFamily: "Nexa Bold 650"),
              ),
            ),
            SizedBox(
              height: screenHeight / 28,
            ),
            textField(
              context,
              hint: "First Name",
              title: 'First Name',
            ),
            SizedBox(
              height: screenHeight / 60,
            ),
            textField(
              context,
              hint: "Last Name",
              title: 'Last Name',
            ),
            SizedBox(
              height: screenHeight / 60,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Date Of Birth",
                style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "Nexa Bold 650",
                  fontSize: screenWidth / 25,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 60,
            ),
            Container(
              height: kToolbarHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black54)),
              child: Container(
                padding: const EdgeInsets.only(left: 11),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Date Of Birth",
                  style: const TextStyle(
                      color: Colors.black54,
                      fontFamily: "Nexa Bold 650",
                      fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 60,
            ),
            textField(
              context,
              hint: "Address",
              title: 'Address',
            ),
          ],
        ),
      ),
    );
  }
}
