import '../models/user_model.dart';

/// Repository interface for User operations
abstract class UserRepository {
  /// Create a new user
  Future<UserModel> createUser({
    required String email,
    required String passwordHash,
  });

  /// Get user by email
  Future<UserModel?> getUserByEmail(String email);

  /// Get user by ID
  Future<UserModel?> getUserById(int id);

  /// Login with email and password hash
  /// Returns the user if credentials are valid, null otherwise
  Future<UserModel?> login({
    required String email,
    required String passwordHash,
  });

  /// Update user's last login time
  Future<void> updateLastLogin(int userId);

  /// Delete user
  Future<void> deleteUser(int userId);

  /// Watch user by ID for changes
  Stream<UserModel?> watchUserById(int userId);
}
