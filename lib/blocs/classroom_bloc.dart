import 'package:classroom/configs/configs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassroomBloc extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future joinClass(String classroomId) async {

    await _firestore.collection(Config.fscClassroom).doc(classroomId).update({});
  }
}
