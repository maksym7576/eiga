import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/config/languages/language_hub.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import '../../styles/additional_window_theme.dart';

class LanguageTokenizationScreen extends ConsumerWidget {
  final String languageName;

  const LanguageTokenizationScreen({
    super.key,
    required this.languageName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final config = LanguageHub.getByName(languageName);
    if (config == null) return const Scaffold(body: Center(child: Text('Language not found')));

    final appConfig = ref.watch(appConfigsServiceProvider);
    final currentMethod = appConfig.getTokenizationMethod(languageName);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Tokenization Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose how ${config.name} text should be split into words:',
              style: TextStyle(color: theme.mutedText, fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            _MethodCard(
              title: 'Local Tokenization',
              subtitle: 'Fast, works offline. Recommended for space-separated languages.',
              icon: Icons.speed_rounded,
              isSelected: currentMethod == TokenizationMethod.local,
              onTap: () async {
                await appConfig.setTokenizationMethod(languageName, TokenizationMethod.local);
                ref.invalidate(appConfigsServiceProvider);
                if (context.mounted) Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _MethodCard(
              title: 'AI Tokenization',
              subtitle: 'Most accurate, handles complex grammar. Requires internet.',
              icon: Icons.auto_awesome_rounded,
              isSelected: currentMethod == TokenizationMethod.ai,
              onTap: () async {
                await appConfig.setTokenizationMethod(languageName, TokenizationMethod.ai);
                ref.invalidate(appConfigsServiceProvider);
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryAccent.withValues(alpha: 0.05) : theme.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? theme.primaryAccent : theme.dividerColor,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? theme.primaryAccent : theme.mutedText.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? Colors.white : theme.mutedText, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? theme.primaryAccent : theme.titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: theme.mutedText, height: 1.4),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: theme.primaryAccent, size: 24),
          ],
        ),
      ),
    );
  }
}
