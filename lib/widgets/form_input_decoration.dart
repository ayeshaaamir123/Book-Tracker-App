import 'package:flutter/material.dart';

InputDecoration formInputDecoration(String label, String hintText) {
  return InputDecoration(
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.purple.shade100, width: 2.0),
      ),
      hintText: hintText,
      labelText: label);
}
