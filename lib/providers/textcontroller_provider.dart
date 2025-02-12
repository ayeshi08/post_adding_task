import 'package:flutter/material.dart';

class TextEditingControllerProvider with ChangeNotifier {
  // Create the TextEditingController
  TextEditingController _namecontroller = TextEditingController();

  TextEditingController get namecontroller => _namecontroller;

  // Update TextEditingController text
  void setText(String newText) {
    _namecontroller.text = newText;
    notifyListeners();
  }
  // Clean up controller when no longer needed
  @override
  void dispose() {
    _namecontroller.dispose();
    super.dispose();
  }
}