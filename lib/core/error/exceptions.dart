/// Base exception class for data layer errors
/// All exceptions in the app should extend this class
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Authentication related exceptions
class AuthException extends AppException {
  const AuthException({required super.message, super.code, super.originalError});
}

class LoginException extends AuthException {
  const LoginException({super.message = '登录失败', super.code, super.originalError});
}

class RegisterException extends AuthException {
  const RegisterException({super.message = '注册失败', super.code, super.originalError});
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException({super.message = '会话已过期', super.code, super.originalError});
}

/// Database related exceptions
class DatabaseException extends AppException {
  const DatabaseException({required super.message, super.code, super.originalError});
}

class ReadException extends DatabaseException {
  const ReadException({super.message = '读取数据失败', super.code, super.originalError});
}

class WriteException extends DatabaseException {
  const WriteException({super.message = '写入数据失败', super.code, super.originalError});
}

class DeleteException extends DatabaseException {
  const DeleteException({super.message = '删除数据失败', super.code, super.originalError});
}

class NotFoundException extends DatabaseException {
  const NotFoundException({super.message = '数据不存在', super.code, super.originalError});
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException({required super.message, super.code, super.originalError});
}

class ApiException extends NetworkException {
  final int? statusCode;

  const ApiException({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
  });

  @override
  String toString() => 'ApiException: $message (status: $statusCode, code: $code)';
}

class TimeoutException extends NetworkException {
  const TimeoutException({super.message = '请求超时', super.code, super.originalError});
}

class NoConnectionException extends NetworkException {
  const NoConnectionException({super.message = '无网络连接', super.code, super.originalError});
}

/// Validation related exceptions
class ValidationException extends AppException {
  const ValidationException({required super.message, super.code, super.originalError});
}

class EmailValidationException extends ValidationException {
  const EmailValidationException({super.message = '邮箱格式无效', super.code, super.originalError});
}

class PasswordValidationException extends ValidationException {
  const PasswordValidationException({super.message = '密码格式无效', super.code, super.originalError});
}

/// AI related exceptions
class AiException extends AppException {
  const AiException({required super.message, super.code, super.originalError});
}

class AiGenerationException extends AiException {
  const AiGenerationException({super.message = 'AI 生成失败', super.code, super.originalError});
}

class AiParseException extends AiException {
  const AiParseException({super.message = 'AI 响应解析失败', super.code, super.originalError});
}

/// General exceptions
class UnknownException extends AppException {
  const UnknownException({super.message = '发生未知错误', super.code, super.originalError});
}
