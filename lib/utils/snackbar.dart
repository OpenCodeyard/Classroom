import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(
          fontFamily: "Varela",
        ),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
