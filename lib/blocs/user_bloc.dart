import 'package:classroom/configs/configs.dart';
import 'package:classroom/screens/onboarding/onboarding_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends ChangeNotifier {
  String _name = "";
  String _uid = "";
  String _email = "";

  String get name => _name;

  String get uid => _uid;

  String get email => _email;

  late GlobalKey<NavigatorState> _navigatorKey;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  UserBloc(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    loadDataFromSp();
  }

  Future saveDataToSp(
    String name,
    String email,
    String uid,
  ) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString(Config.prefName, name);
    sp.setString(Config.prefEmail, email);
    sp.setString(Config.prefUID, uid);
    sp.setBool(Config.prefLoggedIn, true);

    notifyListeners();

    _name = name;
    _email = email;
    _uid = uid;
    notifyListeners();
  }

  Future loadDataFromSp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _name = sp.getString(Config.prefName) ?? "";
    _email = sp.getString(Config.prefEmail) ?? "";
    _uid = sp.getString(Config.prefUID) ?? "";
    notifyListeners();
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();

    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    _name = "";
    _uid = "";
    _email = "";
    notifyListeners();

    if (_navigatorKey.currentState != null) {
      Navigator.pushAndRemoveUntil(
        _navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
        (route) => false,
      );
    }
  }
}
