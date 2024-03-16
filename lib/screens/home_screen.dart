import 'package:attendance/colors/colors.dart';
import 'package:attendance/models/user_model.dart';
import 'package:attendance/screens/check_screen.dart';
import 'package:attendance/screens/history_screen.dart';
import 'package:attendance/screens/user_screen.dart';
import 'package:attendance/services/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    getID().then((value) {
      _getCredentials();
      _getProfilePic();
    });
  }

  void _getProfilePic() async {
    var doc = await FirebaseFirestore.instance
        .collection('Employee')
        .doc(UserModel.id)
        .get();
    setState(() {
      UserModel.profilePicLink = doc['profilePic'];
    });
  }

  void _getCredentials() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Employee')
        .doc(UserModel.id)
        .get();
    setState(() {
      UserModel.canEdit = doc['canEdit'];
      UserModel.firstName = doc['firstName'];
      UserModel.lastName = doc['lastName'];
      UserModel.birthDate = doc['birthDate'];
      UserModel.address = doc['address'];
    });
  }

  void _startLocationService() async {
    LocationService().initialize();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    UserModel.lat = position.latitude;
    UserModel.long = position.longitude;
  }

  Future<void> getID() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Employee")
        .where("id", isEqualTo: UserModel.employeeID)
        .get();
    UserModel.id = snapshot.docs[0].id;
  }

  @override
  Widget build(BuildContext context) {
    _startLocationService();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      body: screens[currentIndex],
      bottomNavigationBar: MoltenBottomNavigationBar(
        margin: const EdgeInsets.all(10),
        borderRaduis: const BorderRadius.all(Radius.circular(10)),
        domeCircleSize: 70,
        barHeight: 70,
        domeCircleColor: primary,
        barColor: primary,
        selectedIndex: currentIndex,
        onTabChange: (clickedIndex) {
          setState(() {
            currentIndex = clickedIndex;
          });
        },
        tabs: [
          MoltenTab(
            icon: const Icon(Icons.calendar_month_outlined),
            unselectedColor: Colors.white,
            title: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: const Text(
                'History',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          MoltenTab(
            icon: const Icon(Icons.check),
            unselectedColor: Colors.white,
            title: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: const Text(
                'Check',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          MoltenTab(
            icon: const Icon(Icons.person),
            unselectedColor: Colors.white,
            title: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: const Text(
                'profile',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //for (int i = 0; i < navIcons.length; i++) ...<Expanded>
  List<Widget> screens = [
    const HistoryScreen(),
    const CheckScreen(),
    const UserScreen()
  ];
}
