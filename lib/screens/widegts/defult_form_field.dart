import 'package:flutter/material.dart';

Widget textField(BuildContext context,
    {required String hint,
    required String title,
    required TextEditingController controller}) {
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontFamily: "Nexa Bold 650",
            fontSize: MediaQuery.of(context).size.width / 25,
          ),
        ),
      ),
      TextFormField(
        controller: controller,
        cursorColor: Colors.black54,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: Colors.black54, fontFamily: "Nexa Bold 650"),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.black54,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.black54,
            ),
          ),
        ),
      ),
    ],
  );
}
