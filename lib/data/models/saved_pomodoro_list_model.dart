import 'package:isar/isar.dart';

part 'saved_pomodoro_list_model.g.dart';

@collection
class SavedPomodoroListModel {
  Id id = Isar.autoIncrement;

  @Index()
  late int userId;

  late String name;

  late String tasksJson;

  int taskCount = 0;

  int totalMinutes = 0;

  late DateTime createdAt;

  DateTime? updatedAt;
}
