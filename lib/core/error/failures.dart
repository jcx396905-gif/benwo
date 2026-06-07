import 'package:equatable/equatable.dart';

/// Base failure class for domain layer errors
/// All failures in the app should extend this class
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Authentication related failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class LoginFailure extends AuthFailure {
  const LoginFailure({super.message = '登录失败，请检查邮箱和密码', super.code});
}

class RegisterFailure extends AuthFailure {
  const RegisterFailure({super.message = '注册失败，请稍后重试', super.code});
}

class LogoutFailure extends AuthFailure {
  const LogoutFailure({super.message = '退出登录失败', super.code});
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure({super.message = '会话已过期，请重新登录', super.code});
}

/// Database related failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.code});
}

class ReadFailure extends DatabaseFailure {
  const ReadFailure({super.message = '读取数据失败', super.code});
}

class WriteFailure extends DatabaseFailure {
  const WriteFailure({super.message = '写入数据失败', super.code});
}

class DeleteFailure extends DatabaseFailure {
  const DeleteFailure({super.message = '删除数据失败', super.code});
}

class NotFoundFailure extends DatabaseFailure {
  const NotFoundFailure({super.message = '数据不存在', super.code});
}

/// Network related failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class ApiFailure extends NetworkFailure {
  final int? statusCode;

  const ApiFailure({
    required super.message,
    super.code,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, code, statusCode];
}

class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure({super.message = '请求超时，请检查网络连接', super.code});
}

class NoConnectionFailure extends NetworkFailure {
  const NoConnectionFailure({super.message = '无网络连接，请检查网络设置', super.code});
}

/// AI/Api related failures
class AiFailure extends Failure {
  const AiFailure({required super.message, super.code});
}

class AiGenerationFailure extends AiFailure {
  const AiGenerationFailure({super.message = 'AI 生成失败，请稍后重试', super.code});
}

class AiParseFailure extends AiFailure {
  const AiParseFailure({super.message = 'AI 响应解析失败', super.code});
}

/// Validation related failures
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

class EmailValidationFailure extends ValidationFailure {
  const EmailValidationFailure({super.message = '请输入有效的邮箱地址', super.code});
}

class PasswordValidationFailure extends ValidationFailure {
  const PasswordValidationFailure({super.message = '密码至少需要 6 个字符', super.code});
}

class RequiredFieldFailure extends ValidationFailure {
  const RequiredFieldFailure({super.message = '此字段为必填项', super.code});
}

/// General failures
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = '发生未知错误', super.code});
}

class CancelledFailure extends Failure {
  const CancelledFailure({super.message = '操作已取消', super.code});
}
