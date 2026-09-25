import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/config/secure_storage.dart';
import 'package:eiga/providers/services/token_provider.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/settings/control_button_widget.dart';
import 'package:eiga/ui/widgets/settings/setting_tile.dart';
import '../general_settings_screen.dart';
import '../reader_preferences_screen.dart';
import '../tokenization_settings_screen.dart';
import '../processing_batch_settings_screen.dart';
import '../anki_settings_screen.dart';
import '../player_settings_screen.dart';
import '../ai_settings_screen.dart';
import '../ai_pipeline_models_screen.dart';
import '../sync_devices_screen.dart';

class SettingsDesktopView extends ConsumerWidget {
  final Future<void> Function(BuildContext) onFullReset;

  const SettingsDesktopView({
    super.key,
    required this.onFullReset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: theme.backgroundColor.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: theme.dividerColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, 'Services', showVersion: true),
                const SizedBox(height: 8),
                _buildServicesCard(context),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'General & Navigation'),
                const SizedBox(height: 8),
                _buildGeneralCard(context),
                const SizedBox(height: 32),
                _buildSectionHeader(context, 'App Language'),
                const SizedBox(height: 8),
                _buildAppLanguageCard(context, ref),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {bool showVersion = false}) {
    final theme = AdditionalWindowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.mutedText,
              letterSpacing: 1.2,
            ),
          ),
          if (showVersion)
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version ?? '...';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.primaryAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'v$version',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryAccent,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildServicesCard(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Consumer(
      builder: (context, ref, child) {
        final geminiToken = ref.watch(tokenProvider(ApiTokenType.gemini)).value ?? '';
        final groqToken = ref.watch(tokenProvider(ApiTokenType.groq)).value ?? '';
        final jimakuToken = ref.watch(tokenProvider(ApiTokenType.jimaku)).value ?? '';

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
          child: Column(
            children: [
              SettingTile(
                title: 'Gemini API Key',
                subtitle: 'Real-time translation & insights',
                icon: Icons.vpn_key_rounded,
                iconColor: Colors.white,
                iconBackground: const [Color(0xFF2563EB), Color(0xFF4F46E5)],
                badgeText: geminiToken.isNotEmpty ? 'Has key' : 'No key',
                badgeColor: geminiToken.isNotEmpty ? Colors.teal : Colors.redAccent,
                onTap: () => ControlButtonWidget.openGeminiKeyDialog(context),
              ),
              Divider(height: 1, color: theme.dividerColor, indent: 64),
              SettingTile(
                title: 'Groq Cloud API Key',
                subtitle: 'Ultra-fast inference speed',
                icon: Icons.speed_rounded,
                iconColor: Colors.white,
                iconBackground: const [Color(0xFFF55036), Color(0xFFD946EF)],
                badgeText: groqToken.isNotEmpty ? 'Has key' : 'No key',
                badgeColor: groqToken.isNotEmpty ? Colors.teal : Colors.redAccent,
                onTap: () => ControlButtonWidget.openGroqKeyDialog(context),
              ),
              Divider(height: 1, color: theme.dividerColor, indent: 64),
              SettingTile(
                title: 'Jimaku API Key',
                subtitle: 'Auto-search for subtitles & dictionaries',
                icon: Icons.vpn_key_rounded,
                iconColor: Colors.white,
                iconBackground: const [Color(0xFF4338CA), Color(0xFF9333EA)],
                badgeText: jimakuToken.isNotEmpty ? 'Has key' : 'No key',
                badgeColor: jimakuToken.isNotEmpty ? Colors.teal : Colors.redAccent,
                onTap: () => ControlButtonWidget.openJimakuKeyDialog(context),
              ),
              Divider(height: 1, color: theme.dividerColor, indent: 64),
              SettingTile(
                title: 'Anki Integration',
                subtitle: 'Configure decks and fields for vocabulary export',
                icon: Icons.star_rounded,
                iconColor: Colors.white,
                iconBackground: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AnkiSettingsScreen()),
                  );
                },
              ),
              Divider(height: 1, color: theme.dividerColor, indent: 64),
              SettingTile(
                title: 'Clear All Data',
                subtitle: 'Permanently delete all videos, phrases, and progress.',
                icon: Icons.delete_forever_rounded,
                iconColor: Colors.redAccent,
                iconBackground: [Colors.redAccent.withValues(alpha: 0.1), Colors.redAccent.withValues(alpha: 0.1)],
                isDestructive: true,
                actionLabel: 'Delete',
                onTap: () => onFullReset(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGeneralCard(BuildContext context) {
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
      child: Column(
        children: [
          SettingTile(
            title: 'AI Settings',
            subtitle: 'Providers, auto-switching & audio chunking',
            icon: Icons.settings_suggest_rounded,
            iconColor: const Color(0xFF6366F1),
            iconBackground: const [Color(0xFFEEF2FF), Color(0xFFEEF2FF)],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiSettingsScreen()),
              );
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 64),
          SettingTile(
            title: 'AI Pipeline & Models',
            subtitle: 'Transcription & 5 linguistic stage models & stats',
            icon: Icons.route_rounded,
            iconColor: const Color(0xFF8B5CF6),
            iconBackground: const [Color(0xFFF5F3FF), Color(0xFFF5F3FF)],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiPipelineModelsScreen()),
              );
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 64),
          SettingTile(
            title: 'Player Settings',
            subtitle: 'Video caching, auto-lock & subtitle preferences',
            icon: Icons.video_settings_rounded,
            iconColor: const Color(0xFF3B82F6),
            iconBackground: const [Color(0xFFEFF6FF), Color(0xFFEFF6FF)],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlayerSettingsScreen()),
              );
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 64),
          SettingTile(
            title: 'Reader Preferences',
            subtitle: 'Choose subtitle text order and display',
            icon: Icons.translate_rounded,
            iconColor: const Color(0xFFF59E0B),
            iconBackground: const [Color(0xFFFEF3C7), Color(0xFFFEF3C7)],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReaderPreferencesScreen()),
              );
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 64),
          SettingTile(
            title: 'Tokenization',
            subtitle: 'Word splitting method (Local/AI)',
            icon: Icons.unfold_more_double_rounded,
            iconColor: const Color(0xFFEC4899),
            iconBackground: const [Color(0xFFFDF2F8), Color(0xFFFDF2F8)],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TokenizationSettingsScreen()),
              );
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 64),
          SettingTile(
            title: 'Batch Sizes',
            subtitle: 'AI request phrase limits',
            icon: Icons.reorder_rounded,
            iconColor: const Color(0xFFF97316),
            iconBackground: const [Color(0xFFFFF7ED), Color(0xFFFFF7ED)],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProcessingBatchSettingsScreen()),
              );
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 64),
          SettingTile(
            title: 'Device Synchronization',
            subtitle: 'Link devices via Camera or QR code',
            icon: Icons.sync_alt_rounded,
            iconColor: Colors.teal,
            iconBackground: const [Color(0xFFE6FFFA), Color(0xFFE6FFFA)],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SyncDevicesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppLanguageCard(BuildContext context, WidgetRef ref) {
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
              }
            },
          ),
        ),
      ),
    );
  }
}
