import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/providers/ui/ai_models_state_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/app_bar/app_blur_header.dart';
import 'package:eiga/providers/services/token_provider.dart';
import 'package:eiga/config/secure_storage.dart';
import 'processing_mode_screen.dart';

class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final config = ref.watch(appConfigsServiceProvider);
    final isAutoSwitch = config.getIsAutomaticModelSwitch;

    final geminiTokenAsync = ref.watch(tokenProvider(ApiTokenType.gemini));
    final groqTokenAsync = ref.watch(tokenProvider(ApiTokenType.groq));

    final hasGeminiToken = geminiTokenAsync.maybeWhen(data: (t) => t.isNotEmpty, orElse: () => false);
    final hasGroqToken = groqTokenAsync.maybeWhen(data: (t) => t.isNotEmpty, orElse: () => false);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: const AppBlurHeader(
        title: 'AI Settings & Providers',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'AI PROVIDERS'),
            const SizedBox(height: 8),
            _buildSwitchCard(
              context,
              title: 'Enable Google Gemini',
              subtitle: 'Use Gemini models for translation and analysis.',
              value: config.getIsGeminiEnabled && hasGeminiToken,
              isEnabled: hasGeminiToken,
              onChanged: (val) async {
                if (!val && !config.getIsGroqEnabled) return; // Prevent disabling all
                await config.setIsGeminiEnabled(val);
                ref.invalidate(aiModelsProvider);
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            _buildSwitchCard(
              context,
              title: 'Enable Groq Cloud',
              subtitle: 'Use Llama 3 & Mixtral via Groq for ultra-fast speed.',
              value: config.getIsGroqEnabled && hasGroqToken,
              isEnabled: hasGroqToken,
              onChanged: (val) async {
                if (!val && !config.getIsGeminiEnabled) return; // Prevent disabling all
                await config.setIsGroqEnabled(val);
                ref.invalidate(aiModelsProvider);
                setState(() {});
              },
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'AI AUTOMATION'),
            const SizedBox(height: 8),
            _buildSwitchCard(
              context,
              title: 'Automatic Model Switching',
              subtitle: 'Switch to fallback models if the current one fails.',
              value: isAutoSwitch,
              onChanged: (val) async {
                await config.setIsAutomaticModelSwitch(val);
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            _buildSwitchCard(
              context,
              title: 'Adaptive Audio Chunking',
              subtitle: 'Automatically reduce chunk size based on model TPM limits.',
              value: config.getIsAdaptiveChunkSizeEnabled,
              onChanged: (val) async {
                await config.setIsAdaptiveChunkSizeEnabled(val);
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            _buildSwitchCard(
              context,
              title: 'Auto-Translate on Import',
              subtitle: 'Start translating the first batch immediately after adding a video.',
              value: config.getAutoTranslateOnImport,
              onChanged: (val) async {
                await config.setAutoTranslateOnImport(val);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = AdditionalWindowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: theme.mutedText,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isEnabled = true,
  }) {
    final theme = AdditionalWindowTheme.of(context);

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: theme.mutedText),
                    ),
                    if (!isEnabled) ...[
                      const SizedBox(height: 6),
                      const Text(
                        'API Key required to enable this provider',
                        style: TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
              Switch.adaptive(
                value: value,
                onChanged: isEnabled ? onChanged : null,
                activeTrackColor: theme.primaryAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingModeCard(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProcessingModeScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.primaryAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.auto_awesome_motion_rounded, color: theme.primaryAccent, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Processing Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.titleColor)),
                  const SizedBox(height: 2),
                  Text('5 Stages (Advanced)', style: TextStyle(fontSize: 12, color: theme.mutedText)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.mutedText.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryAccent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.primaryAccent.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: theme.primaryAccent, size: 20),
              const SizedBox(width: 10),
              Text(
                'How AI Fallbacks work',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoItem(
            context,
            'Detection:',
            'App detects errors like "Rate Limit" or "Server Unavailable" from AI providers.',
          ),
          const SizedBox(height: 10),
          _buildInfoItem(
            context,
            'Fallback:',
            'If enabled, it immediately tries another available model from your list.',
          ),
          const SizedBox(height: 10),
          _buildInfoItem(
            context,
            'Reliability:',
            'Models that fail are deprioritized until their daily limits reset.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String text) {
    final theme = AdditionalWindowTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.titleColor,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: theme.mutedText,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
