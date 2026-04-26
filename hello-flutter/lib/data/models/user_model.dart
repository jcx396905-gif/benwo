import 'package:isar/isar.dart';

part 'user_model.g.dart';

/// User model for authentication
@collection
class UserModel {
  Id id = Isar.autoIncrement;

  /// Email address (unique identifier for login)
  @Index(unique: true)
  late String email;

  /// Hashed password (never store plain text)
  late String passwordHash;

  /// Creation timestamp
  late DateTime createdAt;

  /// Last login timestamp
  DateTime? lastLoginAt;
}
