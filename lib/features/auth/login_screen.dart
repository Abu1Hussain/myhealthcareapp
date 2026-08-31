library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myhealth_ai/app/router.dart';
import 'package:myhealth_ai/app/theme/app_assets.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';

import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/quick_switch_user_dialog.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'ali.jaafar@student.uob.bh');
  final _passwordController = TextEditingController(text: 'Patient123!');
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // A "Switch Account" pick pre-fills the email so the user only needs
    // to re-enter their password, never a stored credential.
    final prefill = ref.read(loginPrefillEmailProvider);
    if (prefill != null && prefill.isNotEmpty) {
      _emailController.text = prefill;
      _passwordController.clear();
      Future.microtask(() => ref.read(loginPrefillEmailProvider.notifier).state = null);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authControllerProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );

    if (success && mounted) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        switch (user.role.name) {
          case 'patient':
            context.go(AppRoutes.patientHome);
          case 'staff':
            context.go(AppRoutes.staffDashboard);
          case 'admin':
            context.go(AppRoutes.adminDashboard);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 960;

    final formColumn = SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isWide) ...[
                _BrandMark(compact: true),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Login Form Card
              DoubleBezelCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Sign in',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter your credentials to access your clinical dashboard.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.textSecondary,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      if (authState.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.critical.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: AppColors.critical.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.critical),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  authState.errorMessage!,
                                  style: const TextStyle(
                                    color: AppColors.critical,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                          prefixIcon: Icon(Icons.email_outlined, size: 20),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter your email';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter your password';
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Submit Button
                      ElevatedButton(
                        onPressed: authState.isLoading ? null : _submit,
                        child: authState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Sign in'),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Quick Demo Account Switcher
                      OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => const QuickSwitchUserDialog(),
                          );
                        },
                        icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                        label: const Text('Quick switch demo account'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: context.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.register),
                    child: const Text('Register as patient'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (!isWide) {
      return Scaffold(body: SafeArea(child: formColumn));
    }

    // Wide (desktop/web) layout: asymmetric split-screen — branded panel
    // on the left, the auth form on the right. Centered single-column
    // login cards look thin and unfinished on a 1440px+ window; this
    // keeps the eye anchored while giving the form its own clear zone.
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: _BrandPanel(),
          ),
          Expanded(
            flex: 4,
            child: SafeArea(child: formColumn),
          ),
        ],
      ),
    );
  }
}

/// Left-hand branded panel shown on wide (desktop/web) viewports.
class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [AppColors.primaryTealDark, Color(0xFF0B4A45)]
              : const [AppColors.primaryTeal, AppColors.primaryTealDark],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: _decorativeCircle(140, Colors.white.withValues(alpha: 0.06)),
          ),
          Positioned(
            bottom: -120,
            left: -60,
            child: _decorativeCircle(220, Colors.white.withValues(alpha: 0.05)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _BrandMark(compact: false, onDark: true),
                  const SizedBox(height: AppSpacing.huge),
                  Text(
                    'Your care, unified — even offline.',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          height: 1.25,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Records, vitals, and appointments stay on-device — with '
                    'AI-assisted summaries and risk-aware scheduling built in.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  const _FeatureRow(
                    icon: Icons.offline_bolt_rounded,
                    label: 'Offline-first local storage',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _FeatureRow(
                    icon: Icons.auto_awesome_rounded,
                    label: 'AI health summaries, always with a safety check',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _FeatureRow(
                    icon: Icons.event_available_rounded,
                    label: 'Predictive no-show scheduling',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _decorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontSize: 13.5, height: 1.4),
          ),
        ),
      ],
    );
  }
}

/// App icon + wordmark, reused compact in the mobile column and larger
/// (on-dark) in the desktop brand panel.
class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.compact, this.onDark = false});

  final bool compact;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 56.0 : 64.0;
    final iconWidget = Image.asset(
      AppAssets.appIcon,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: onDark ? Colors.white.withValues(alpha: 0.15) : AppColors.primaryTealSurface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.health_and_safety_rounded,
          size: size * 0.66,
          color: onDark ? Colors.white : AppColors.primaryTeal,
        ),
      ),
    );

    if (compact) {
      return Column(
        children: [
          iconWidget,
          const SizedBox(height: AppSpacing.md),
          Text(
            'MyHealth AI',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Offline-First Personal Health & Triage',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.textSecondary,
                ),
          ),
        ],
      );
    }

    return Row(
      children: [
        iconWidget,
        const SizedBox(width: AppSpacing.md),
        Text(
          'MyHealth AI',
          style: TextStyle(
            color: onDark ? Colors.white : Theme.of(context).colorScheme.onSurface,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
