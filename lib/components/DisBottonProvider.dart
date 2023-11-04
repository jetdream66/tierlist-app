import 'package:flutter/material.dart';

class DisBottonProvider with ChangeNotifier {
  bool _disBotton = false;

  bool get disBotton => _disBotton;

  set disBotton(bool value) {
    _disBotton = value;
    notifyListeners();
  }
}
