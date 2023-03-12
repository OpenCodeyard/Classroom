import 'package:freezed_annotation/freezed_annotation.dart';

// part 'classroom_model.g.dart';   // Use if from json is necessary
part 'classroom_model.freezed.dart';

@freezed
class ClassroomModel with _$ClassroomModel {

  const factory ClassroomModel({
    required String createdAt,
    required String createdBy,
    required String name,
    required String color,
    required String details,
    required List<String> students,
  }) = _ClassroomModel;

}