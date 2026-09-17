import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/settings/control_button_widget.dart';
import 'package:eiga/ui/widgets/settings/setting_tile.dart';
import '../general_settings_screen.dart';
import '../reader_preferences_screen.dart';
import '../tokenization_settings_screen.dart';
import '../processing_batch_settings_screen.dart';
import '../anki_settings_screen.dart';

class SettingsDesktopView extends StatelessWidget {
  final Future<void> Function(BuildContext) onFullReset;

  const SettingsDesktopView({
    super.key,
    required this.onFullReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: theme.dividerColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column 1: Services
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(context, 'Services', showVersion: true),
                          const SizedBox(height: 12),
                          _buildServicesCard(context),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Column 2: General
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(context, 'General'),
                          const SizedBox(height: 12),
                          _buildGeneralCard(context),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                const Center(
                  child: Text(
                    'EIGA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                      letterSpacing: 4.0,
                    ),
                  ),
                ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primaryAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'v$version',
                    style: TextStyle(
                      fontSize: 11,
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

    return Container(
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
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
            badgeText: 'Has key',
            badgeColor: Colors.teal,
            onTap: () => ControlButtonWidget.openGeminiKeyDialog(context),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 64),
          SettingTile(
            title: 'Jimaku API Key',
            subtitle: 'Auto-search for subtitles & dictionaries',
            icon: Icons.vpn_key_rounded,
            iconColor: Colors.white,
            iconBackground: const [Color(0xFF4338CA), Color(0xFF9333EA)],
            badgeText: 'Has key',
            badgeColor: Colors.teal,
            onTap: () => ControlButtonWidget.openJimakuKeyDialog(context),
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 64),
          SettingTile(
            title: 'Wyzie API Key',
            subtitle: 'Auto-search for subtitles on Wyzie Subs',
            icon: Icons.vpn_key_rounded,
            iconColor: Colors.white,
            iconBackground: const [Color(0xFFEA580C), Color(0xFFF97316)],
            badgeText: 'Has key',
            badgeColor: Colors.teal,
            onTap: () => ControlButtonWidget.openWyzieKeyDialog(context),
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
            actionLabel: 'Delete All',
            onTap: () => onFullReset(context),
          ),
        ],
      ),
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
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          SettingTile(
            title: 'General Settings',
            subtitle: 'AI automation and system behavior',
            icon: Icons.settings_suggest_rounded,
            iconColor: Colors.blue.shade700,
            iconBackground: [Colors.blue.shade50, Colors.blue.shade50],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GeneralSettingsScreen()),
              );
            },
          ),
          Divider(height: 1, color: theme.dividerColor, indent: 64),
          SettingTile(
            title: 'Reader Preferences',
            subtitle: 'Choose subtitle text order and display',
            icon: Icons.menu_book_rounded,
            iconColor: Colors.amber.shade700,
            iconBackground: [Colors.amber.shade50, Colors.amber.shade50],
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
            icon: Icons.extension_rounded,
            iconColor: Colors.purple.shade700,
            iconBackground: [Colors.purple.shade50, Colors.purple.shade50],
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
            icon: Icons.layers_rounded,
            iconColor: Colors.orange.shade700,
            iconBackground: [Colors.orange.shade50, Colors.orange.shade50],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProcessingBatchSettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
