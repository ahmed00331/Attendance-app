import 'package:attendance/colors/colors.dart';
import 'package:attendance/models/user_model.dart';
import 'package:attendance/screens/check_screen.dart';
import 'package:attendance/screens/history_screen.dart';
import 'package:attendance/screens/user_screen.dart';
import 'package:attendance/services/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  int currentIndex = 1;
  List<IconData> navIcons = [
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user
  ];

  @override
  void initState() {
    super.initState();
    getID();
    _startLocationService();
  }

  void _startLocationService() async {
    LocationService().initialize();
    LocationService().getLatitude().then((value) {
      setState(() {
        UserModel.lat = value!;
      });
    });
    LocationService().getLongitude().then((value) {
      setState(() {
        UserModel.long = value!;
      });
    });
  }

  void getID() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Employee")
        .where("id", isEqualTo: UserModel.employeeID)
        .get();
    UserModel.id = snapshot.docs[0].id;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        height: screenHeight / 12,
        margin: EdgeInsets.symmetric(
            vertical: screenHeight / 40, horizontal: screenWidth / 50),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(40),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navIcons.length; i++) ...<Expanded>{
                Expanded(
                  child: InkWell(
                    overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            navIcons[i],
                            color: i == currentIndex ? primary : Colors.black45,
                            size: i == currentIndex ? 28 : 25,
                          ),
                          i == currentIndex
                              ? Container(
                            margin: const EdgeInsets.only(top: 6),
                            height: 3,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(40)),
                                color: primary),
                          )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              }
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> screens = [
    const HistoryScreen(),
    const CheckScreen(),
    const UserScreen()
  ];
}
