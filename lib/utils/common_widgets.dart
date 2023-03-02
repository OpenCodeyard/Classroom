import 'package:flutter/material.dart';

Widget customText(String label, {Color? color}) {
  return Text(
    label,
    style: TextStyle(
      color: color ?? Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 19,
      fontFamily: "PublicSans",
    ),
  );
}

Widget customTextInputField(TextEditingController controller, String hinttext) {
  return TextFormField(
    controller: controller,
    cursorColor: Colors.deepPurpleAccent,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: hinttext,
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent))
    ),
  );
}
