import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../providers/database/database_providers.dart';
import '../../providers/services/app_configs_provider.dart';
import '../styles/additional_window_theme.dart';
import '../widgets/settings/control_button_widget.dart';
import 'settings/reader_preferences_screen.dart';
import 'settings/general_settings_screen.dart';
import 'settings/tokenization_settings_screen.dart';
import 'settings/processing_batch_settings_screen.dart';
import '../../providers/ui/redirect_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(openGeminiDialogProvider)) {
        ref.read(openGeminiDialogProvider.notifier).state = false;
        ControlButtonWidget.openGeminiKeyDialog(context);
      }
      if (ref.read(openJimakuDialogProvider)) {
        ref.read(openJimakuDialogProvider.notifier).state = false;
        ControlButtonWidget.openJimakuKeyDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, size: 20),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: theme.dividerColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Services', showVersion: true),
            const SizedBox(height: 8),
            _buildServicesCard(context),
            const SizedBox(height: 28),
            _buildSectionHeader(context, 'General'),
            const SizedBox(height: 8),
            _buildGeneralCard(context),
            const SizedBox(height: 48),
            const Center(
              child: Text(
                'EIGA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
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
          _SettingTile(
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
          _SettingTile(
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
          _SettingTile(
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
          _SettingTile(
            title: 'Clear All Data',
            subtitle: 'Permanently delete all videos, phrases, and progress.',
            icon: Icons.delete_forever_rounded,
            iconColor: Colors.redAccent,
            iconBackground: [Colors.redAccent.withValues(alpha: 0.1), Colors.redAccent.withValues(alpha: 0.1)],
            isDestructive: true,
            actionLabel: 'Delete',
            onTap: () => _handleFullReset(context),
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
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _SettingTile(
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
          _SettingTile(
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
          _SettingTile(
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
          _SettingTile(
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

  Future<void> _handleFullReset(BuildContext context) async {
    final theme = AdditionalWindowTheme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reset All Data?', style: TextStyle(color: theme.titleColor, fontWeight: FontWeight.bold)),
        content: Text(
          'This will clear all your videos and history. This action cannot be undone.',
          style: TextStyle(color: theme.normalText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: theme.mutedText)),
          ),
          FilledButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(isarServiceProvider).clearAllData();
      await ref.read(appConfigsServiceProvider).resetToDefault();
    }
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<Color> iconBackground;
  final String? badgeText;
  final Color? badgeColor;
  final String? actionLabel;
  final bool isDestructive;
  final VoidCallback onTap;

  const _SettingTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.badgeText,
    this.badgeColor,
    this.actionLabel,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isDestructive ? 20 : 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: iconBackground.length > 1 
                      ? LinearGradient(colors: iconBackground, begin: Alignment.bottomLeft, end: Alignment.topRight)
                      : null,
                  color: iconBackground.length == 1 ? iconBackground.first : null,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDestructive ? Colors.redAccent : theme.titleColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: badgeColor?.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: badgeColor?.withValues(alpha: 0.2) ?? Colors.transparent),
                            ),
                            child: Text(
                              badgeText!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: theme.mutedText),
                    ),
                  ],
                ),
              ),
              if (actionLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                )
              else
                Icon(Icons.chevron_right_rounded, color: theme.mutedText.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
