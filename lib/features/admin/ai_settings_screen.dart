library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/data/seed/seeder.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/services/ai/claude_ai_service.dart';

class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _mockMode = true;
  String _selectedModel = 'claude-3-5-sonnet-20241022';
  bool _isSeeding = false;
  bool _obscureKey = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settingsResult = await ref.read(adminRepositoryProvider).getAppSettings();
    settingsResult.fold(
      (state) {
        setState(() {
          _mockMode = state.mockMode;
          _selectedModel = state.modelId;
        });
      },
      (_) {},
    );

    final key = await ClaudeAiService.loadApiKey();
    if (key != null && key.isNotEmpty) {
      _apiKeyController.text = key;
    }
  }

  Future<void> _saveSettings() async {
    await ref.read(adminRepositoryProvider).updateAppSettings(
          mockMode: _mockMode,
          modelId: _selectedModel,
          aiEnabled: true,
        );

    final key = _apiKeyController.text.trim();
    if (key.isNotEmpty) {
      await ClaudeAiService.saveApiKey(key);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI Configuration saved successfully.')),
      );
    }
  }

  Future<void> _reSeedDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Re-Seed Database?'),
        content: const Text('This will reset local SQLite data and re-generate 60 patients and 2 years of clinical history. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Re-Seed', style: TextStyle(color: AppColors.critical)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isSeeding = true);
      final db = ref.read(appDatabaseProvider);
      final seeder = DatabaseSeeder(db);
      await seeder.seedAll();
      setState(() => _isSeeding = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Database seeded successfully with 60 patients.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Configuration & Governance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            tooltip: 'Save Settings',
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dual AI Architecture Info Card
              DoubleBezelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_awesome_rounded, color: AppColors.aiAccent),
                        SizedBox(width: 8),
                        Text(
                          'Dual AI Architecture (Offline / Claude)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'MyHealth AI features a resilient dual-mode strategy. When Mock Mode is enabled, the system uses deterministic medical summarization without network requests (100% defense insurance). When disabled, it calls the Anthropic Messages API.',
                      style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                    ),
                    const Divider(height: 24),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mock AI Mode (Offline Defense Insurance)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Guaranteed working demo without API keys or internet', style: TextStyle(fontSize: 12)),
                      value: _mockMode,
                      onChanged: (val) => setState(() => _mockMode = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Claude Configuration Card
              DoubleBezelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anthropic Claude API Configuration',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      value: _selectedModel,
                      decoration: const InputDecoration(labelText: 'Active Claude Model'),
                      items: const [
                        DropdownMenuItem(
                          value: 'claude-3-5-sonnet-20241022',
                          child: Text('Claude 3.5 Sonnet (Recommended)'),
                        ),
                        DropdownMenuItem(
                          value: 'claude-3-5-haiku-20241022',
                          child: Text('Claude 3.5 Haiku (Fastest)'),
                        ),
                        DropdownMenuItem(
                          value: 'claude-3-opus-20240229',
                          child: Text('Claude 3 Opus (Most Powerful)'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedModel = val);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _apiKeyController,
                      obscureText: _obscureKey,
                      decoration: InputDecoration(
                        labelText: 'Anthropic API Key (sk-ant-...)',
                        hintText: 'sk-ant-api03-...',
                        suffixIcon: IconButton(
                          icon: Icon(_obscureKey ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                          onPressed: () => setState(() => _obscureKey = !_obscureKey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Database Re-Seeder Section
              DoubleBezelCard(
                borderColor: AppColors.warning,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.storage_rounded, color: AppColors.warning),
                        SizedBox(width: 8),
                        Text(
                          'Database Synthetic Seeder',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Generates 60 realistic patient personas, 12 staff clinicians, and 2 years of simulated vitals and encounters.',
                      style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
                      onPressed: _isSeeding ? null : _reSeedDatabase,
                      icon: const Icon(Icons.refresh_rounded),
                      label: _isSeeding
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Re-Seed 60 Patients'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
