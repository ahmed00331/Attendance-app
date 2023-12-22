import 'dart:async';

import 'package:attendance/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  final GlobalKey<SlideActionState> key = GlobalKey();
  String checkIn = '--/--';
  String checkOut = '--/--';

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where("id", isEqualTo: User.userName)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMM yyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = '--/--';
        checkOut = '--/--';
      });
    }
    print(User.userName);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: screenHeight / 28),
              child: Text(
                "Welcome,",
                style: TextStyle(
                    fontSize: screenWidth / 20,
                    fontFamily: 'Nexa Light 350',
                    color: Colors.black54,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Employee,",
                      style: TextStyle(
                          fontSize: screenWidth / 18,
                          fontFamily: 'Nexa Bold 650',
                          color: Colors.black),
                    ),
                    TextSpan(
                      text: "   ${User.userName}",
                      style: TextStyle(
                          fontSize: screenWidth / 18,
                          fontFamily: 'Nexa Bold 650',
                          color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: screenHeight / 28),
              child: Text(
                "Today's Status,",
                style: TextStyle(
                  fontSize: screenWidth / 18,
                  fontFamily: 'Nexa Bold 650',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: screenHeight / 35, bottom: screenHeight / 30),
              height: screenWidth / 2.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2)),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Check In",
                          style: TextStyle(
                              fontSize: screenWidth / 20,
                              color: Colors.black54,
                              fontFamily: 'Nexa Light 350',
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          checkIn,
                          style: TextStyle(
                            fontSize: screenWidth / 18,
                            fontFamily: 'Nexa Bold 650',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Check Out",
                          style: TextStyle(
                              fontSize: screenWidth / 20,
                              color: Colors.black54,
                              fontFamily: 'Nexa Light 350',
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          checkOut,
                          style: TextStyle(
                            fontSize: screenWidth / 18,
                            fontFamily: 'Nexa Bold 650',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                    text: "${DateTime.now().day}/",
                    style: TextStyle(
                      fontSize: screenWidth / 18,
                      fontFamily: 'Nexa Bold 650',
                      color: primary,
                    ),
                    children: [
                      TextSpan(
                        text: DateFormat('MM/yyy').format(DateTime.now()),
                        style: TextStyle(
                            fontSize: screenWidth / 18,
                            fontFamily: 'Nexa Bold 650',
                            color: Colors.black),
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: screenHeight / 100,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat('hh:mm a').format(DateTime.now()),
                style: TextStyle(
                  fontSize: screenWidth / 20,
                  color: Colors.black54,
                  fontFamily: 'Nexa Bold 650',
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 10,
            ),
            checkOut == '--/--'
                ? Builder(
                    builder: (context) {
                      return SlideAction(
                        outerColor: Colors.white,
                        innerColor: primary,
                        text: checkIn == '--/--'
                            ? 'Slide To Check In'
                            : 'Slide To Check Out',
                        textStyle: TextStyle(
                            fontFamily: 'Nexa Light 350',
                            fontSize: screenWidth / 18),
                        textColor: Colors.black54,
                        key: key,
                        onSubmit: () async {
                          if (mounted) {
                            Timer(const Duration(seconds: 1), () {
                              key.currentState?.reset();
                            });
                          }

                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("Employee")
                              .where("id", isEqualTo: User.userName)
                              .get();

                          DocumentSnapshot snap2 = await FirebaseFirestore
                              .instance
                              .collection("Employee")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .doc(DateFormat('dd MMM yyy')
                                  .format(DateTime.now()))
                              .get();

                          try {
                            String checkIn = snap2["checkIn"];
                            setState(() {
                              checkOut =
                                  DateFormat('hh:mm').format(DateTime.now());
                            });
                            await FirebaseFirestore.instance
                                .collection("Employee")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMM yyy')
                                    .format(DateTime.now()))
                                .update({
                              'checkIn': checkIn,
                              'checkOut':
                                  DateFormat('hh:mm').format(DateTime.now())
                            });
                          } catch (e) {
                            setState(() {
                              checkIn =
                                  DateFormat('hh:mm').format(DateTime.now());
                            });
                            await FirebaseFirestore.instance
                                .collection("Employee")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMM yyy')
                                    .format(DateTime.now()))
                                .set({
                              'checkIn':
                                  DateFormat('hh:mm').format(DateTime.now())
                            });
                          }
                        },
                      );
                    },
                  )
                : Text(
                    "You Have Completed This Day",
                    style: TextStyle(
                      fontSize: screenWidth / 20,
                      color: Colors.black54,
                      fontFamily: 'Nexa Bold 650',
                    ),
                  )
          ],
        ));
  }
}
