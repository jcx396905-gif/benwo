import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Simple password hashing utility using SHA256
/// Note: For production, use bcrypt or argon2
class AuthUtils {
  AuthUtils._();

  /// Hash a password using SHA256
  /// Note: In production, use bcrypt or argon2 for better security
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify a password against a hash
  static bool verifyPassword(String password, String hash) {
    return hashPassword(password) == hash;
  }
}