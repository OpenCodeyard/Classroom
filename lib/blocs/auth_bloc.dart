import 'package:classroom/app_navigation_controller.dart';
import 'package:classroom/blocs/user_bloc.dart';
import 'package:classroom/configs/configs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Provider for user authentication
class AuthenticationBloc extends ChangeNotifier {
  bool _isSignUp = false;

  bool get isSignUp => _isSignUp;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _uid;

  String? get uid => _uid;

  ///Returns a list containing login status and onboard completed status
  /// List element 0 : Login status :: [False] -> Non logged in user
  /// List element 1 : Onboarding status :: [False] -> Non onboarded in user
  /// List element 2 : Permission status :: [False] -> Permissions not accepted by user
  Future<bool>? checkSignIn(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLoggedIn = sp.getBool(Config.prefLoggedIn) ?? false;
    return Future.value(isLoggedIn);
  }

  Future checkIfUserExists(String email) async {
    await FirebaseFirestore.instance
        .collection(Config.fscUser)
        .where(Config.fsfEmail, isEqualTo: email)
        .limit(1)
        .get()
        .then(
      (value) {
        if (value.docs.isEmpty) {
          _isSignUp = true;
        } else if (!value.docs[0].exists) {
          _isSignUp = true;
        }
      },
    );
    notifyListeners();
  }

  ///Toggle loading status
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  ///Save new user data to FireStore
  Future signUp(
    String email,
    String name,
    BuildContext context,
    UserBloc ub,
  ) async {
    DateTime now = DateTime.now();
    FirebaseFirestore.instance.collection(Config.fscUser).doc(uid).set({
      Config.fsfEmail: email,
      Config.fsfCreatedAt: now,
      Config.fsfName: name.trim(),
      Config.fsfUID: uid,
    }).then((value) async {
      clearFields();

      await ub.saveDataToSp(
        name,
        email,
        uid ?? "",
      );
      setLoading(false);
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) {
        return const AppNavigationController();
      }),
      (route) => false,
    );
  }

  ///Fetch logged in user data from database
  Future fetchDataFromFirebase(UserBloc ub, BuildContext context) async {
    DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
        .instance
        .collection(Config.fscUser)
        .doc(uid)
        .get();

    Map<String, dynamic>? data = snap.data();
    if (data != null) {
      clearFields();
      await ub.saveDataToSp(
        data[Config.fsfName],
        data[Config.fsfEmail],
        data[Config.fsfUID],
      );

      setLoading(false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const AppNavigationController();
        }),
        (route) => false,
      );
    } else {
      setLoading(false);
    }
  }

  ///Clear fields
  void clearFields() {
    _isLoading = false;
    _isSignUp = false;
  }
}
