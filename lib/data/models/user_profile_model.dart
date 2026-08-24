import 'package:isar/isar.dart';

part 'user_profile_model.g.dart';

@collection
class UserProfileModel {
  static const Id singletonId = 1;

  Id id = singletonId;

  String? communicationStyle;

  String? bestWorkTime;

  String? taskPace;

  late DateTime createdAt;

  DateTime? updatedAt;
}
