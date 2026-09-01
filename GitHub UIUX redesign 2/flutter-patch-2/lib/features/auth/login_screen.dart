library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myhealth_ai/app/router.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/quick_switch_user_dialog.dart';

/// Sign in.
///
/// The repo's asymmetric split — brand panel left, form right — is kept,
/// because it was the right structure. What goes is the teal gradient and
/// the two decorative circles: on paper the left panel is set type and a
/// hairline, and the promise the product makes carries it.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // A "Switch account" pick pre-fills the email so the user only needs to
    // re-enter their password, never a stored credential.
    final prefill = ref.read(loginPrefillEmailProvider);
    if (prefill != null && prefill.isNotEmpty) {
      _emailController.text = prefill;
      Future.microtask(
        () => ref.read(loginPrefillEmailProvider.notifier).state = null,
      );
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
          _emailController.text.trim(),
          _passwordController.text,
        );

    if (!success || !mounted) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    switch (user.role.name) {
      case 'patient':
        context.go(AppRoutes.patientHome);
      case 'staff':
        context.go(AppRoutes.staffDashboard);
      case 'admin':
        context.go(AppRoutes.adminDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 960;

    if (!isWide) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                _Promise(compact: true),
                const SizedBox(height: AppSpacing.xxxl),
                _form(),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 5, child: SafeArea(child: _Promise())),
          Container(
            width: 1,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.16),
          ),
          Expanded(
            flex: 4,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xxxl),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: _form(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign in',
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 30,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your record opens on this device only.',
            style: theme.textTheme.bodyMedium,
          ),

          if (authState.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.accent2900
                    : AppColors.accent2100,
                border: const Border(
                  left: BorderSide(color: AppColors.magentaInk, width: 3),
                ),
              ),
              child: Text(
                authState.errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),
          Text('Email address', style: theme.textTheme.labelMedium),
          const SizedBox(height: 5),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(hintText: 'you@example.com'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter your email';
              if (!v.contains('@')) return 'That does not look like an email';
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.md),
          Text('Password', style: theme.textTheme.labelMedium),
          const SizedBox(height: 5),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                tooltip: _obscure ? 'Show password' : 'Hide password',
                icon: Icon(
                  _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 19,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Enter your password' : null,
          ),

          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: authState.isLoading ? null : _submit,
              child: Text(authState.isLoading ? 'Signing in…' : 'Sign in'),
            ),
          ),

          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text("New here?", style: theme.textTheme.bodyMedium),
              TextButton(
                onPressed: () => context.go(AppRoutes.register),
                child: const Text('Register as a patient'),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xxl),
          Container(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.16),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Demo accounts'),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const QuickSwitchUserDialog(),
                  ),
                  icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                  label: const Text('Pick a demo account'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The left panel: what the product promises, set as type.
class _Promise extends StatelessWidget {
  const _Promise({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(compact ? 0 : AppSpacing.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            compact ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
        children: [
          const Eyebrow('MyHealth AI'),
          if (!compact) const Spacer(),
          if (compact) const SizedBox(height: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your care, unified —\neven offline.',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontSize: compact ? 32 : 44,
                  letterSpacing: -1.4,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  'Records, vitals and appointments stay on the device, with '
                  'AI-assisted summaries and risk-aware scheduling built in.',
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
              ),
              if (!compact) ...[
                const SizedBox(height: AppSpacing.xxl),
                const _PromiseLine(
                  icon: Icons.cloud_off_rounded,
                  text: 'Offline-first local storage',
                ),
                const _PromiseLine(
                  icon: Icons.verified_outlined,
                  text: 'Every AI summary carries a safety check',
                ),
                const _PromiseLine(
                  icon: Icons.event_available_rounded,
                  text: 'Scheduling that predicts missed appointments',
                ),
              ],
            ],
          ),
          if (!compact) const Spacer(),
          if (!compact)
            Text(
              'University of Bahrain final-year project · Flutter, Drift, '
              'on-device inference',
              style: theme.textTheme.labelSmall,
            ),
        ],
      ),
    );
  }
}

class _PromiseLine extends StatelessWidget {
  const _PromiseLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: theme.brightness == Brightness.dark
                ? AppColors.accent300
                : AppColors.accent700,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
