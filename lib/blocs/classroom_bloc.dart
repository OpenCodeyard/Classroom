import 'package:classroom/configs/configs.dart';
import 'package:classroom/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassroomBloc extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  //Toggle loading status
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future joinClass(
      BuildContext context, String classroomId, String userId) async {
    setLoading(true);
    try {
      // Add that student to class -
      await _firestore.collection(Config.fscClassroom).doc(classroomId).update({
        'students': FieldValue.arrayUnion([userId])
      });

      // Add that class to that user's joined classes
      await _firestore.collection(Config.fscUser).doc(userId).update({
        'joinedClasses': FieldValue.arrayUnion([classroomId])
      });

      setLoading(false);
    } catch (e) {
      setLoading(false);
      showSnackBar(context, e.toString());
    }
  }

  Future createClass(BuildContext context, String classroomName, String userId,
      String classColor, String classDetails) async {
    setLoading(true);
    try {
      DateTime now = DateTime.now();
      //Create Class
      DocumentReference createdClass =
          await _firestore.collection(Config.fscClassroom).add({
        'createdAt': now,
        'createdBy': userId,
        'name': classroomName,
        'color': classColor,
        'details': classDetails,
        'students': [userId],
      });
      //Add Created class uid in that user classes
      await _firestore.collection(Config.fscUser).doc(userId).update({
        'createdClasses': FieldValue.arrayUnion([createdClass.id]),
        'joinedClasses': FieldValue.arrayUnion([createdClass.id]),
      });

      setLoading(false);
    } catch (e) {
      setLoading(false);
      showSnackBar(context, e.toString());
    }
  }
}
