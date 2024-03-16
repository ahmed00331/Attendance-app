import 'dart:io';

import 'package:attendance/colors/colors.dart';
import 'package:attendance/models/user_model.dart';
import 'package:attendance/screens/widegts/custome_snack_bar.dart';
import 'package:attendance/screens/widegts/defult_form_field.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

enum AppState { free, picked, cropped }

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  String birth = 'Date Of Birth';
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var addressController = TextEditingController();

  void uploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    var reference = FirebaseStorage.instance
        .ref()
        .child('${UserModel.employeeID?.toLowerCase()}-profilePic.jpg');
    await reference.putFile(File(image!.path));
    reference.getDownloadURL().then((value) async {
      setState(() {
        UserModel.profilePicLink = value;
      });
      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(UserModel.id)
          .update({'profilePic': UserModel.profilePicLink});
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  uploadImage();
                },
                child: Stack(alignment: Alignment.bottomCenter, children: [
                  CircleAvatar(
                    radius: 70,
                    child: Center(
                      child: UserModel.profilePicLink == null
                          ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: CachedNetworkImage(
                                imageUrl: UserModel.profilePicLink ??
                                    "http://via.placeholder.com/200x150",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                    ),
                  ),
                  const Icon(
                    Icons.camera_alt,
                    size: 25,
                    opticalSize: 12,
                  ),
                ]),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Employee ${UserModel.employeeID}",
                  style: TextStyle(
                      fontSize: screenWidth / 23, fontFamily: "Nexa Bold 650"),
                ),
              ),
              SizedBox(
                height: screenHeight / 28,
              ),
              UserModel.canEdit
                  ? textField(context,
                      hint: "First Name",
                      title: 'First Name',
                      controller: firstNameController)
                  : dataField('First Name', UserModel.firstName ?? ""),
              UserModel.canEdit
                  ? textField(context,
                      hint: "Last Name",
                      title: 'Last Name',
                      controller: lastNameController)
                  : dataField("Last Name", UserModel.lastName ?? ''),
              InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
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
                    ).then((value) {
                      setState(() {
                        birth = DateFormat("dd/MM/yyy").format(value!);
                      });
                    });
                  },
                  child:
                      dataField("Date of Birth", UserModel.birthDate ?? birth)),
              UserModel.canEdit
                  ? textField(context,
                      hint: "Address",
                      title: 'Address',
                      controller: addressController)
                  : dataField('Address', UserModel.address ?? ""),
              const SizedBox(
                height: 20,
              ),
              UserModel.canEdit
                  ? InkWell(
                      onTap: () async {
                        String firstName = firstNameController.text;
                        String lastName = lastNameController.text;
                        String birthDate = birth;
                        String address = addressController.text;

                        if (UserModel.canEdit) {
                          if (firstName.isEmpty) {
                            showSnackBar(context,
                                error: 'first name is empty',
                                contentType: ContentType.failure);
                          } else if (lastName.isEmpty) {
                            showErrorSnackBar(error: 'last name is empty');
                          } else if (birthDate.isEmpty) {
                            showErrorSnackBar(error: 'birth date is empty');
                          } else if (address.isEmpty) {
                            showErrorSnackBar(error: 'address name is empty');
                          } else {
                            await FirebaseFirestore.instance
                                .collection('Employee')
                                .doc(UserModel.id)
                                .update({
                              'firstName': firstName,
                              'lastName': lastName,
                              'birthDate': birthDate,
                              'address': address,
                              'canEdit': false
                            }).then((value) {
                              UserModel.canEdit = false;
                              setState(() {});
                            });
                          }
                        } else {
                          showErrorSnackBar(error: 'you can\'t edit anymore');
                        }
                      },
                      child: Container(
                        height: kToolbarHeight,
                        padding: const EdgeInsets.only(left: 11),
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(15)),
                        alignment: Alignment.center,
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Nexa Bold 650",
                              fontSize: 25),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget dataField(String title, String txt) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "Nexa Bold 650",
              fontSize: screenWidth / 25,
            ),
          ),
        ),
        Container(
          height: kToolbarHeight,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.only(left: 11),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              txt,
              style: const TextStyle(
                  color: Colors.black54,
                  fontFamily: "Nexa Bold 650",
                  fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  showErrorSnackBar({required String error}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error!',
        message: error,
        contentType: ContentType.failure,
      ),
    ));
  }
}
