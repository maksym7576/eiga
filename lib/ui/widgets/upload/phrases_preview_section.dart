import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';
import '../dialogs/app_bottom_sheet.dart';
import '../shared/app_section_card.dart';
import '../shared/app_text_button.dart';

class PhrasesPreviewSection extends ConsumerWidget {
  const PhrasesPreviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);

    if (!state.isParsing && state.previewPhrases.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppSectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: theme.isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.slate50,
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.checklist_rounded, size: 14, color: theme.primaryAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Phrases Preview',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: theme.normalText),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${state.previewPhrases.length} lines)',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: theme.mutedText),
                    ),
                  ],
                ),
                if (state.previewPhrases.length > 5)
                  AppTextButton(
                    onPressed: () => _showAllPhrases(context, state, theme),
                    text: 'See all phrases',
                  ),
              ],
            ),
          ),
          _buildPhrasesList(theme, state),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showAllPhrases(BuildContext context, UploadState state, AdditionalWindowTheme theme) {
    AppBottomSheet.show(
      context: context,
      heightFactor: 0.9,
      child: _PhrasesFullView(phrases: state.previewPhrases, theme: theme),
    );
  }

  Widget _buildPhrasesList(AdditionalWindowTheme theme, UploadState state) {
    if (state.isParsing) {
      return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.previewPhrases.length > 5 ? 5 : state.previewPhrases.length,
      separatorBuilder: (context, index) => Divider(height: 1, color: theme.dividerColor),
      itemBuilder: (context, index) {
        final phrase = state.previewPhrases[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  _formatTime(phrase.startTime), 
                  style: TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.w500, color: theme.mutedText)
                ),
              ),
              Expanded(
                child: Text(
                  phrase.originalPhrase ?? '', 
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.normalText)
                ),
              ),
              const SizedBox(width: 8),
              if (phrase.translatedPhrase != null)
                Text(
                  phrase.translatedPhrase!,
                  style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: theme.mutedText),
                ),
            ],
          ),
        );
      },
    );
  }

  static String _formatTime(DateTime? time) {
    if (time == null) return '00:00:00';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}

class _PhrasesFullView extends StatelessWidget {
  final List<dynamic> phrases;
  final AdditionalWindowTheme theme;

  const _PhrasesFullView({required this.phrases, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Phrases',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: theme.normalText),
                    ),
                    Text(
                      '${phrases.length} lines detected',
                      style: TextStyle(fontSize: 12, color: theme.mutedText),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, color: theme.mutedText),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(right: 8),
              itemCount: phrases.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: theme.dividerColor),
              itemBuilder: (context, index) {
                final phrase = phrases[index];
                return ListTile(
                  dense: true,
                  leading: Text(
                    PhrasesPreviewSection._formatTime(phrase.startTime), 
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: theme.mutedText)
                  ),
                  title: Text(
                    phrase.originalPhrase ?? '', 
                    style: TextStyle(fontSize: 14, color: theme.normalText, fontWeight: FontWeight.w500)
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
