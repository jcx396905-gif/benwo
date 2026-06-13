import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/liquid_glass.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return '请输入邮箱';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return '请输入有效的邮箱格式';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return '请输入密码';
    if (value.length < 6) return '密码至少需要6个字符';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return '请确认密码';
    if (value != _passwordController.text) return '两次输入的密码不一致';
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await ref
        .read(authNotifierProvider.notifier)
        .register(email: email, password: password);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('注册成功！请完成您的个人资料'),
          backgroundColor: AppColors.primary,
        ),
      );
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final errorMessage = authState.errorMessage;

    return Scaffold(
      body: LiquidGlassBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: LiquidGlassIconButton(
                        tooltip: '返回登录',
                        onPressed: isLoading ? null : () => context.go('/login'),
                        icon: Icons.arrow_back_rounded,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const LiquidGlassIcon(icon: Icons.person_add_rounded),
                    const SizedBox(height: 24),
                    Text(
                      '创建账号',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: Colors.white, fontSize: 36),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '先了解你，再帮你拆目标',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: Colors.white, height: 1.25),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '注册后用几步建立用户画像，让 AI 计划更贴近你的节奏',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    LiquidGlassPanel(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '账号信息',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: '邮箱',
                                hintText: '请输入您的邮箱',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: _validateEmail,
                              enabled: !isLoading,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: '密码',
                                hintText: '至少 6 个字符',
                                prefixIcon: const Icon(Icons.lock_outlined),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: LiquidGlassIconButton(
                                  tooltip: _obscurePassword ? '显示密码' : '隐藏密码',
                                    icon: _obscurePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  onPressed: isLoading
                                      ? null
                                      : () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                ),
                                ),
                              ),
                              validator: _validatePassword,
                              enabled: !isLoading,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleRegister(),
                              decoration: InputDecoration(
                                labelText: '确认密码',
                                hintText: '请再次输入密码',
                                prefixIcon: const Icon(Icons.lock_outlined),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: LiquidGlassIconButton(
                                  tooltip: _obscureConfirmPassword
                                      ? '显示密码'
                                      : '隐藏密码',
                                    icon: _obscureConfirmPassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  onPressed: isLoading
                                      ? null
                                      : () => setState(
                                          () => _obscureConfirmPassword =
                                              !_obscureConfirmPassword,
                                        ),
                                ),
                                ),
                              ),
                              validator: _validateConfirmPassword,
                              enabled: !isLoading,
                            ),
                            if (errorMessage != null) ...[
                              const SizedBox(height: 14),
                              _AuthError(message: errorMessage),
                            ],
                            const SizedBox(height: 22),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _handleRegister,
                                child: isLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Text('创建并继续'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: isLoading ? null : () => context.go('/login'),
                      child: const Text('已有账号？立即登录'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthError extends StatelessWidget {
  final String message;

  const _AuthError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
