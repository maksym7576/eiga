import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/redirect_providers.dart';
import '../../../providers/services/token_provider.dart';
import '../../../config/secure_storage.dart';
import '../../styles/additional_window_theme.dart';

class SubtitleSourceSelector extends ConsumerWidget {
  const SubtitleSourceSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final subtitleSource = ref.watch(uploadProvider.select((s) => s.subtitleSource));
    final notifier = ref.read(uploadProvider.notifier);
    
    final jimakuToken = ref.watch(tokenProvider(ApiTokenType.jimaku)).value ?? '';
    final hasToken = jimakuToken.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // More compact padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtitles:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: theme.normalText,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Slate 100
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggleButton(
                      context, 
                      label: 'Local', 
                      icon: Icons.folder_open, 
                      isActive: subtitleSource == SubtitleSource.local,
                      onTap: () => notifier.setSubtitleSource(SubtitleSource.local),
                    ),
                    const SizedBox(width: 2),
                    _buildToggleButton(
                      context, 
                      label: 'Jimaku', 
                      icon: Icons.cloud_outlined, 
                      isActive: subtitleSource == SubtitleSource.jimaku,
                      onTap: hasToken ? () => notifier.setSubtitleSource(SubtitleSource.jimaku) : () {},
                      opacity: hasToken ? 1.0 : 0.6,
                      trailing: !hasToken ? Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7), // Yellow 100
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xFFFDE68A)), // Yellow 200
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber_rounded, size: 8, color: Color(0xFF92400E)), // Amber 800
                            SizedBox(width: 1),
                            Text(
                              'NO TOKEN',
                              style: TextStyle(
                                fontSize: 7,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF92400E),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ) : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!hasToken) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 14, color: theme.mutedText),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Jimaku requires API token in Settings',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: theme.mutedText,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/settings'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.primaryAccent,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                  child: const Text('Configure'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildToggleButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    Widget? trailing,
    double opacity = 1.0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ] : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13,
                color: isActive ? const Color(0xFF3B66F5) : const Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? const Color(0xFF3B66F5) : const Color(0xFF64748B),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  void _handleJimakuTap(BuildContext context, WidgetRef ref, UploadNotifier notifier) async {
    final token = await SecureTokenStorage.getToken(ApiTokenType.jimaku);
    if (token.isEmpty) {
      ref.read(openJimakuDialogProvider.notifier).state = true;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter Jimaku API key first')),
        );
        context.push('/settings');
      }
    } else {
      notifier.setSubtitleSource(SubtitleSource.jimaku);
    }
  }
}
