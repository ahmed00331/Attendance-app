import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

showSnackBar(BuildContext context,
    {required String error, required ContentType contentType}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Error!',
      message: error,
      contentType: contentType,
    ),
  ));
}
