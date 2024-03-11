import 'dart:async';

import 'package:attendance/models/user_model.dart';
import 'package:attendance/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../colors/colors.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  final GlobalKey<SlideActionState> key = GlobalKey();
  String checkIn = '--/--';
  String checkOut = '--/--';
  String location = '';
  String? locationCache;
  String key2 = "location_cache";

  @override
  void initState() {
    super.initState();
    _getRecord();
    retrieveAddress().then(_updateName);
  }

  Future<bool> saveAddress(String address) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key2, location);
  }

  Future<String> retrieveAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getString(key2) ?? "";
  }

  void save() {
    String address = location;
    saveAddress(address);
  }

  void _updateName(String address) {
    setState(() {
      locationCache = address;
    });
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    UserModel.lat = position.latitude;
    UserModel.long = position.longitude;
    List<Placemark> p =
        await placemarkFromCoordinates(UserModel.lat ?? 0, UserModel.long ?? 0);
    Placemark place = p[0];
    setState(() {
      location =
          "${place.street}, ${place.administrativeArea},${place.country},";
      saveAddress(location);
    });
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where("id", isEqualTo: UserModel.employeeID)
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
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
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
                const Spacer(),
                Container(
                  margin: EdgeInsets.only(top: screenHeight / 28),
                  child: IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance
                            .signOut()
                            .then((value) async {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          await preferences.remove('employeeId');
                        });
                      },
                      icon: const Icon(Icons.logout)),
                )
              ],
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
                      text: "   ${UserModel.employeeID}",
                      style: TextStyle(
                          fontSize: screenWidth / 18,
                          fontFamily: 'Nexa Bold 650',
                          color: primary),
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
              child: StreamBuilder(
                  stream: Stream.periodic(const Duration(minutes: 1)),
                  builder: (context, snapshot) {
                    return Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                        fontFamily: 'Nexa Bold 650',
                      ),
                    );
                  }),
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
                            : '   Slide To Check Out',
                        textStyle: TextStyle(
                            fontFamily: 'Nexa Light 350',
                            fontSize: screenWidth / 18),
                        textColor: Colors.black54,
                        key: key,
                        onSubmit: () async {
                          if (UserModel.lat != 0) {
                            _getLocation();
                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection("Employee")
                                .where("id", isEqualTo: UserModel.employeeID)
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
                                checkOut = DateFormat('hh:mm a')
                                    .format(DateTime.now());
                              });
                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMM yyy')
                                      .format(DateTime.now()))
                                  .update({
                                'date': Timestamp.now(),
                                'checkIn': checkIn,
                                'checkOut': DateFormat('hh:mm a')
                                    .format(DateTime.now()),
                                'checkOutLocation': location
                              });
                            } catch (e) {
                              setState(() {
                                checkIn = DateFormat('hh:mm a')
                                    .format(DateTime.now());
                              });
                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMM yyy')
                                      .format(DateTime.now()))
                                  .set({
                                'date': Timestamp.now(),
                                'checkIn': DateFormat('hh:mm a')
                                    .format(DateTime.now()),
                                'checkOut': '--/--',
                                'checkInLocation': location
                              });
                            }
                            // key.currentState!.reset();
                          } else {
                            Timer(const Duration(seconds: 3), () async {
                              _getLocation();

                              QuerySnapshot snap = await FirebaseFirestore
                                  .instance
                                  .collection("Employee")
                                  .where("id", isEqualTo: UserModel.employeeID)
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
                                  checkOut = DateFormat('hh:mm a')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("Employee")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat('dd MMM yyy')
                                        .format(DateTime.now()))
                                    .update({
                                  'date': Timestamp.now(),
                                  'checkIn': checkIn,
                                  'checkOut': DateFormat('hh:mm a')
                                      .format(DateTime.now()),
                                  'checkOutLocation': location
                                });
                              } catch (e) {
                                setState(() {
                                  checkIn = DateFormat('hh:mm a')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("Employee")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat('dd MMM yyy')
                                        .format(DateTime.now()))
                                    .set({
                                  'date': Timestamp.now(),
                                  'checkIn': DateFormat('hh:mm a')
                                      .format(DateTime.now()),
                                  'checkOut': '--/--',
                                  'checkInLocation': location
                                });
                              }
                              key.currentState!.reset();
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
                  ),
            SizedBox(height: screenHeight / 50),
            location != ""
                ? Text(
                    "location: $location",
                    style: TextStyle(
                      fontSize: screenWidth / 20,
                      color: Colors.black54,
                      fontFamily: 'Nexa Bold 650',
                    ),
                  )
                : Text(
                    "last location: $locationCache",
                    style: TextStyle(
                      fontSize: screenWidth / 20,
                      color: Colors.black54,
                      fontFamily: 'Nexa Bold 650',
                    ),
                  ),
          ],
        ));
  }
}
