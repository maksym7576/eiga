import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/app_bar/app_blur_header.dart';

class PlayerSettingsScreen extends ConsumerStatefulWidget {
  const PlayerSettingsScreen({super.key});

  @override
  ConsumerState<PlayerSettingsScreen> createState() => _PlayerSettingsScreenState();
}

class _PlayerSettingsScreenState extends ConsumerState<PlayerSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final config = ref.watch(appConfigsServiceProvider);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: const AppBlurHeader(
        title: 'Player & Subtitle Settings',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            _buildSectionHeader(context, 'SUBTITLES DISPLAY & EDITING'),
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
              activeTrackColor: theme.primaryAccent,
            ),
          ],
        ),
      ),
    );
  }
}
