import 'package:flutter/material.dart';

class PasswordVisibility extends ChangeNotifier {
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();  // Notify listeners when state changes
  }
}