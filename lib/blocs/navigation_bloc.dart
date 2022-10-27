import 'package:flutter/material.dart';

class NavigationBloc extends ChangeNotifier {
  int _bottomNavIndex = 0;

  int get bottomNavIndex => _bottomNavIndex;

  changeNavIndex(int index) {
    _bottomNavIndex = index;
    notifyListeners();
  }
}
