import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/language.dart';
import '../../../providers/services/database_services_providers.dart';
import '../../../providers/videoComponentsProvider.dart';
import '../../styles/additional_window_theme.dart';

class LanguageTokenizationScreen extends ConsumerWidget {
  final int languageId;

  const LanguageTokenizationScreen({
    super.key,
    required this.languageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final languageService = ref.watch(languageServiceProvider);

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
      body: FutureBuilder<Language?>(
        future: languageService.getLanguageById(languageId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final lang = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose how ${lang.name} text should be split into words:',
                  style: TextStyle(color: theme.mutedText, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                _MethodCard(
                  title: 'Local Tokenization',
                  subtitle: 'Fast, works offline. Recommended for space-separated languages.',
                  icon: Icons.speed_rounded,
                  isSelected: lang.tokenizationMethod == TokenizationMethod.local,
                  onTap: () async {
                    lang.tokenizationMethod = TokenizationMethod.local;
                    await languageService.updateLanguage(lang);
                    ref.invalidate(allLanguagesProvider);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _MethodCard(
                  title: 'AI Tokenization',
                  subtitle: 'Most accurate, handles complex grammar. Requires internet.',
                  icon: Icons.auto_awesome_rounded,
                  isSelected: lang.tokenizationMethod == TokenizationMethod.ai,
                  onTap: () async {
                    lang.tokenizationMethod = TokenizationMethod.ai;
                    await languageService.updateLanguage(lang);
                    ref.invalidate(allLanguagesProvider);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
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
