import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/config/localization/localization_hub.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/providers/ui/ai_models_state_provider.dart';
import '../../../config/pipelines/pipeline_steps.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';
import 'model_selection_screen.dart';
import 'processing_mode_screen.dart';

import '../../widgets/app_bar/app_blur_header.dart';

class GeneralSettingsScreen extends ConsumerStatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  ConsumerState<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends ConsumerState<GeneralSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final config = ref.watch(appConfigsServiceProvider);
    final isAutoSwitch = config.getIsAutomaticModelSwitch;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: const AppBlurHeader(
        title: 'General Settings',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'APP INTERFACE'),
            const SizedBox(height: 8),
            _buildAppLanguageCard(context),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'PROCESSING'),
            const SizedBox(height: 8),
            _buildProcessingModeCard(context),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'STORAGE'),
            const SizedBox(height: 8),
            _buildSwitchCard(
              context,
              title: 'Video Caching',
              subtitle: 'Copy video files to app storage for offline access.',
              value: config.getVideoCachingEnabled,
              onChanged: (val) async {
                await config.setVideoCachingEnabled(val);
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
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'PLAYER AUTOMATION'),
            const SizedBox(height: 8),
            _buildSwitchCard(
              context,
              title: 'Full-screen Auto-Lock',
              subtitle: 'Automatically lock screen controls after 10 seconds in full-screen.',
              value: config.getIsAutoLockEnabled,
              onChanged: (val) async {
                await config.setIsAutoLockEnabled(val);
                setState(() {});
              },
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'SUBTITLES'),
            const SizedBox(height: 8),
            _buildSwitchCard(
              context,
              title: 'Hide content in brackets',
              subtitle: 'Remove text inside (parentheses) from subtitles.',
              value: config.getHideParenthesesContent,
              onChanged: (val) async {
                await config.setHideParenthesesContent(val);
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            _buildSwitchCard(
              context,
              title: 'Auto-shrink long subtitles',
              subtitle: 'Scale down text to fit in fullscreen (min 70%).',
              value: config.getFullscreenAutoShrink,
              onChanged: (val) async {
                await config.setFullscreenAutoShrink(val);
                setState(() {});
              },
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'STAGE MODELS'),
            const SizedBox(height: 8),
            _buildModelButtonsGrid(context),
            const SizedBox(height: 24),
            _buildInfoCard(context),
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
  }) {
    final theme = AdditionalWindowTheme.of(context);

    return Container(
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
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: theme.primaryAccent,
            ),
          ],
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
                  Text('4 Stages (Advanced)', style: TextStyle(fontSize: 12, color: theme.mutedText)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.mutedText.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildModelButtonsGrid(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final aiState = ref.watch(aiModelsProvider);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: TranslationPipelineStep.values.map((step) {
        final activeModel = aiState[step] ?? 'Auto';
        return _ModelSelectionButton(
          step: step,
          modelName: activeModel,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ModelSelectionScreen(step: step)));
          },
        );
      }).toList(),
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
                'How it works',
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
            'App detects errors like "Rate Limit" or "Server Unavailable" from Gemini.',
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

  Widget _buildAppLanguageCard(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final config = ref.watch(appConfigsServiceProvider);
    final currentLang = config.getAppLanguage;

    final Map<String, String> languages = {
      'en': 'English',
      'uk': 'Українська',
    };

    return Container(
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentLang,
            isExpanded: true,
            icon: Icon(Icons.language_rounded, color: theme.primaryAccent, size: 20),
            items: languages.entries.map((e) {
              return DropdownMenuItem(
                value: e.key,
                child: Text(
                  e.value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.titleColor),
                ),
              );
            }).toList(),
            onChanged: (val) async {
              if (val != null) {
                await config.setAppLanguage(val);
                ref.invalidate(appConfigsServiceProvider);
                setState(() {});
              }
            },
          ),
        ),
      ),
    );
  }
}

class _ModelSelectionButton extends StatelessWidget {
  final TranslationPipelineStep step;
  final String modelName;
  final VoidCallback onTap;

  const _ModelSelectionButton({
    required this.step,
    required this.modelName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              step.displayName.toUpperCase(),
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: theme.mutedText, letterSpacing: 0.5),
            ),
            const SizedBox(height: 4),
            Text(
              modelName,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.primaryAccent),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
