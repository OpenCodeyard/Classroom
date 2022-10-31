import 'package:classroom/app_navigation_controller.dart';
import 'package:classroom/blocs/user_bloc.dart';
import 'package:classroom/configs/configs.dart';
import 'package:classroom/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Provider for user authentication
class AuthenticationBloc extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ///Returns a boolean indicating whether an active user login exists
  Future<bool>? checkSignIn(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLoggedIn = sp.getBool(Config.prefLoggedIn) ?? false;
    return Future.value(isLoggedIn);
  }

  Future signInWithGoogle(
    BuildContext context,
    UserBloc ub,
  ) async {
    GoogleSignInAccount? googleSignInAccount;

    // Trigger the authentication flow
    try {
      googleSignInAccount = await GoogleSignIn().signIn();
    } on PlatformException catch (e) {
      toggleInProgressStatus(false);
      if (e.code == GoogleSignIn.kSignInCanceledError ||
          e.code == "popup_closed_by_user") {
        showSnackBar(
          context,
          "Sign In cancelled",
        );
      } else if (e.code == GoogleSignIn.kNetworkError) {
        showSnackBar(
          context,
          "Network Error!",
        );
      } else {
        showSnackBar(
          context,
          e.message ?? "Unknown. Contact Support",
        );

        // print(e.message);
      }
    } catch (e) {
      toggleInProgressStatus(false);
      showSnackBar(
        context,
        "Unknown. Contact Support",
      );
    }

    if (googleSignInAccount == null) {
      toggleInProgressStatus(false);
      showSnackBar(context, "Authentication failed");
      return;
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    User? user;

    try {
      userCredential = await _auth.signInWithCredential(credential);

      user = userCredential.user;
    } catch (e) {
      toggleInProgressStatus(false);
      showSnackBar(
        context,
        e.toString(),
      );
    }

    if (user != null) {
      bool existingUser = await checkIfUserExists(user.email ?? "");

      if (!existingUser) {
        await signUp(
            user.email ?? "", user.displayName ?? "", user.uid, context, ub);
      } else {
        await fetchDataFromFirebase(user.uid, ub, context);
      }

      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const AppNavigationController();
      }));

      toggleInProgressStatus(false);
    } else {
      toggleInProgressStatus(false);
      showSnackBar(
        context,
        "There was problem logging you in. Please try again",
      );
    }
  }

  Future checkIfUserExists(String email) async {
    bool exists = true;

    await FirebaseFirestore.instance
        .collection(Config.fscUser)
        .where(Config.fsfEmail, isEqualTo: email)
        .limit(1)
        .get()
        .then(
      (value) {
        if (value.docs.isEmpty || !value.docs[0].exists) {
          exists = false;
        }
      },
    );
    return exists;
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
    String uid,
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
        uid,
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
  Future fetchDataFromFirebase(
      String uid, UserBloc ub, BuildContext context) async {
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
  }

  void toggleInProgressStatus(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
