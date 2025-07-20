import 'package:flutter/material.dart';

class ErrorViewModel extends ChangeNotifier {
  Exception? error;

  void setError(Exception e) {
    error = e;
    notifyListeners();
  }

  void clear() {
    error = null;
    notifyListeners();
  }
}
