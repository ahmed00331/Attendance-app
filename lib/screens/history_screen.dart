import 'package:attendance/colors/colors.dart';
import 'package:attendance/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  String _month = DateFormat("MMMM").format(DateTime.now());

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
              "My Attendance",
              style: TextStyle(
                fontSize: screenWidth / 18,
                fontFamily: 'Nexa Bold 650',
                color: Colors.black,
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: screenHeight / 28),
                child: Text(
                  _month,
                  style: TextStyle(
                    fontSize: screenWidth / 18,
                    fontFamily: 'Nexa Bold 650',
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: screenHeight / 28),
                child: InkWell(
                  onTap: () async {
                    final month = await showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2099),
                      builder: (context, child) {
                        return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                  primary: primary, secondary: primary),
                              textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                      foregroundColor: primary)),
                            ),
                            child: child!);
                      },
                    );
                    if (month != null) {
                      setState(() {
                        _month = DateFormat("MMMM").format(month);
                      });
                    }
                  },
                  child: Text(
                    "Pick a Month",
                    style: TextStyle(
                      fontSize: screenWidth / 18,
                      fontFamily: 'Nexa Bold 650',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight / 1.2,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Employee")
                  .doc(UserModel.id ?? 'No data')
                  .collection("Record")
                  .snapshots(),
              builder: (context, snapshot) {
                final historyList = snapshot.data?.docs ?? [];
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      return DateFormat('MMMM').format(
                                  historyList[index]['date'].toDate()) ==
                              _month
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: index > 0 ? screenHeight / 60 : 0,
                                  horizontal: screenWidth / 70),
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          DateFormat('EE\ndd').format(
                                              historyList[index]['date']
                                                  .toDate()),
                                          style: TextStyle(
                                            fontSize: screenWidth / 18,
                                            color: Colors.white,
                                            fontFamily: 'Nexa Bold 650',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check In",
                                          style: TextStyle(
                                              fontSize: screenWidth / 25,
                                              color: Colors.black54,
                                              fontFamily: 'Nexa Light 350',
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          historyList[index]['checkIn'],
                                          style: TextStyle(
                                            fontSize: screenWidth / 25,
                                            fontFamily: 'Nexa Bold 650',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Check Out",
                                          style: TextStyle(
                                              fontSize: screenWidth / 25,
                                              color: Colors.black54,
                                              fontFamily: 'Nexa Light 350',
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          historyList[index]['checkOut'],
                                          style: TextStyle(
                                            fontSize: screenWidth / 25,
                                            fontFamily: 'Nexa Bold 650',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox();
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
