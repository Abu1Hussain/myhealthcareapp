library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/data/seed/seeder.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/services/ai/claude_ai_service.dart';

/// AI configuration and governance.
///
/// Same three concerns as before — which service answers, which key it uses,
/// and the synthetic seeder — but stated as a single column of settings
/// rather than three stacked cards, and with the copy saying what each one
/// does rather than how confident the author was about it.
class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _mockMode = true;
  String _model = 'claude-3-5-sonnet-20241022';
  bool _obscureKey = true;
  bool _seeding = false;
  bool _loaded = false;

  static const Map<String, String> _models = {
    'claude-3-5-sonnet-20241022': 'Sonnet — the balanced default',
    'claude-3-5-haiku-20241022': 'Haiku — fastest, cheapest',
    'claude-3-opus-20240229': 'Opus — slowest, most thorough',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await ref.read(adminRepositoryProvider).getAppSettings();
    settings.fold((state) {
      if (!mounted) return;
      setState(() {
        _mockMode = state.mockMode;
        if (_models.containsKey(state.modelId)) _model = state.modelId;
      });
    }, (_) {});

    final key = await ClaudeAiService.loadApiKey();
    if (!mounted) return;
    setState(() {
      if (key != null && key.isNotEmpty) _apiKeyController.text = key;
      _loaded = true;
    });
  }

  Future<void> _save() async {
    await ref.read(adminRepositoryProvider).updateAppSettings(
          mockMode: _mockMode,
          modelId: _model,
          aiEnabled: true,
        );

    final key = _apiKeyController.text.trim();
    if (key.isNotEmpty) await ClaudeAiService.saveApiKey(key);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved.')),
    );
  }

  Future<void> _reseed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Replace all local data?'),
        content: const Text(
          'Every record currently on this device is deleted and rebuilt: 60 '
          'patients, 12 clinicians, and two years of appointments, vitals and '
          'encounters. Accounts created by hand are lost too. This cannot be '
          'undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep what is here'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete and re-seed'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _seeding = true);
    await DatabaseSeeder(ref.read(appDatabaseProvider)).seedAll();
    if (!mounted) return;
    setState(() => _seeding = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Database re-seeded.')),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Eyebrow('Administration'),
                          const SizedBox(height: 6),
                          Text(
                            'How the AI behaves',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontSize: 30,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _loaded ? _save : null,
                      child: const Text('Save'),
                    ),
                  ],
                ),

                // ── Which service answers ─────────────────────────────
                const SizedBox(height: AppSpacing.xxl),
                const SectionHead(title: 'Which service answers'),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'With on-device summarisation selected, the app produces '
                  'summaries deterministically and makes no network request — '
                  'a demo or a clinic without connectivity behaves identically '
                  'to one with it. Turn it off and summaries are generated by '
                  'the Anthropic Messages API instead.',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Switch(
                      value: _mockMode,
                      onChanged: (v) => setState(() => _mockMode = v),
                      activeThumbColor: theme.brightness == Brightness.dark
                          ? AppColors.accent400
                          : AppColors.cyanInk,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        _mockMode
                            ? 'On-device summarisation. No key required, no '
                                'request leaves the handset.'
                            : 'Anthropic API. A key is required below, and '
                                'record context is sent to Anthropic.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),

                // ── The model and key ─────────────────────────────────
                const SizedBox(height: AppSpacing.xxl),
                const SectionHead(title: 'Model and credentials'),
                const SizedBox(height: AppSpacing.md),
                Text('Model', style: theme.textTheme.labelMedium),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  initialValue: _model,
                  items: _models.entries
                      .map((e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _model = v);
                  },
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _model,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Anthropic API key', style: theme.textTheme.labelMedium),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _apiKeyController,
                  obscureText: _obscureKey,
                  decoration: InputDecoration(
                    hintText: 'sk-ant-api03-…',
                    suffixIcon: IconButton(
                      tooltip: _obscureKey ? 'Show key' : 'Hide key',
                      icon: Icon(
                        _obscureKey
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 19,
                      ),
                      onPressed: () => setState(() => _obscureKey = !_obscureKey),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Stored in the platform keystore, never in the database or '
                  'in shared preferences.',
                  style: theme.textTheme.labelSmall,
                ),

                // ── Safety, stated as non-negotiable ──────────────────
                const SizedBox(height: AppSpacing.xxl),
                const SectionHead(title: 'Safety'),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'The clinical safety notice cannot be switched off '
                        'while summaries are enabled. It prints on every '
                        'AI-generated surface in the app.',
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                      ),
                    ),
                  ],
                ),

                // ── Seeder ────────────────────────────────────────────
                const SizedBox(height: AppSpacing.xxl),
                const SectionHead(title: 'Synthetic data', emphasis: true),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Rebuilds the local database from the seed generator: 60 '
                  'patient personas with correlated chronic conditions, 12 '
                  'clinicians across 5 departments, and two years of '
                  'appointments, lab panels and vitals. Everything currently '
                  'stored on this device is destroyed first.',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  onPressed: _seeding ? null : _reseed,
                  child: Text(_seeding ? 'Re-seeding…' : 'Delete and re-seed'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
