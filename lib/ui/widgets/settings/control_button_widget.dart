import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../config/secure_storage.dart';
import '../../../providers/database/database_providers.dart';
import '../../../providers/services/token_provider.dart';
import '../../../providers/ui/redirect_providers.dart';
import '../../../models/settings/guide_step.dart';
import '../../styles/additional_window_theme.dart';
import '../../screens/settings/api_key_config_screen.dart';

class ControlButtonWidget extends ConsumerStatefulWidget {
  const ControlButtonWidget({super.key});

  static void openGeminiKeyDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ApiKeyConfigScreen(
          type: ApiTokenType.gemini,
          title: 'Gemini API Key',
          description: 'Real-time Japanese translation & insights',
          iconGradient: [Color(0xFF2563EB), Color(0xFF4F46E5)],
          icon: Icons.vpn_key_rounded,
          steps: [
            GuideStep(
              title: 'Go to Google AI Studio',
              link: 'https://ai.google.dev/aistudio',
              linkLabel: 'Open Google AI Studio',
            ),
            GuideStep(
              title: 'Sign in with your Google Account',
              subtitle: 'Use your standard Gmail or Google account',
            ),
            GuideStep(
              title: 'Click "Get API key" in the left menu',
            ),
            GuideStep(
              title: 'Click "Create API key"',
              subtitle: 'Choose or create a project, then copy the key',
            ),
          ],
        ),
      ),
    );
  }

  static void openJimakuKeyDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ApiKeyConfigScreen(
          type: ApiTokenType.jimaku,
          title: 'Jimaku API Key',
          description: 'Auto-search for subtitles & dictionaries',
          iconGradient: [Color(0xFF4338CA), Color(0xFF9333EA)],
          icon: Icons.vpn_key_rounded,
          steps: [
            GuideStep(
              title: 'Go to Jimaku Login',
              link: 'https://jimaku.cc/login',
              linkLabel: 'Open Jimaku',
            ),
            GuideStep(
              title: 'Sign in to your account',
              subtitle: 'Use your standard Username and Password',
            ),
            GuideStep(
              title: 'Open "Account Settings"',
              subtitle: 'Click your profile name, then go to Developer Access',
            ),
            GuideStep(
              title: 'Click "Generate" API key',
              subtitle: 'Generate and copy the key',
            ),
          ],
        ),
      ),
    );
  }

  static void openWyzieKeyDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ApiKeyConfigScreen(
          type: ApiTokenType.wyzie,
          title: 'Wyzie API Key',
          description: 'Auto-search for subtitles on Wyzie Subs',
          iconGradient: [Color(0xFFEA580C), Color(0xFFF97316)],
          icon: Icons.vpn_key_rounded,
          steps: [
            GuideStep(
              title: 'Go to Wyzie Subs Login',
              link: 'https://wyzie.xyz/login',
              linkLabel: 'Open Wyzie',
            ),
            GuideStep(
              title: 'Sign in to your account',
            ),
            GuideStep(
              title: 'Open "Developer Dashboard"',
            ),
            GuideStep(
              title: 'Generate or copy your API Token',
            ),
          ],
        ),
      ),
    );
  }

  static void _openSettingDialogStatic(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
  }) {
    final theme = AdditionalWindowTheme.of(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'SettingsDialog',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: theme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: builder(context),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.85,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutBack)),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  ConsumerState<ControlButtonWidget> createState() =>
      _ControlButtonWidgetState();
}

class _ControlButtonWidgetState extends ConsumerState<ControlButtonWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(openJimakuDialogProvider)) {
        ref.read(openJimakuDialogProvider.notifier).state = false;
        ControlButtonWidget.openJimakuKeyDialog(context);
      }
    });
  }

  Widget _settingsButton(
    BuildContext context, {
    required String title,
    required VoidCallback onPressed,
  }) {
    final theme = AdditionalWindowTheme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.addButtonBackground,
        foregroundColor: theme.addButtonText,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _settingsButton(
                context,
                title: 'Gemini key',
                onPressed: () => ControlButtonWidget.openGeminiKeyDialog(context),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _settingsButton(
                context,
                title: 'Jimaku key',
                onPressed: () => ControlButtonWidget.openJimakuKeyDialog(context),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _settingsButton(
                context,
                title: 'Wyzie key',
                onPressed: () => ControlButtonWidget.openWyzieKeyDialog(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _settingsButton(
          context,
          title: 'Clear Database',
          onPressed: () => ControlButtonWidget._openSettingDialogStatic(
            context,
            title: 'Clear Database',
            builder: (context) => _clearDatabaseDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _clearDatabaseDialog(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Consumer(
      builder: (context, ref, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Delete All Data?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.titleColor),
            ),
            const SizedBox(height: 12),
            Text(
              'This will permanently delete all your videos, history, and progress. This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: theme.normalText),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.cancelButtonText,
                      side: BorderSide(color: theme.dividerColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(isarServiceProvider)
                          .clearAllData();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Database cleared successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
