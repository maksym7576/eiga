import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../dialogs/app_bottom_sheet.dart';

import '../shared/section_title.dart';

class PhrasesPreviewSection extends ConsumerWidget {
  const PhrasesPreviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);

    if (!state.isParsing && state.previewPhrases.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SectionTitle(title: 'Phrases Preview'),
            if (state.previewPhrases.isNotEmpty)
              TextButton(
                onPressed: () => _showAllPhrases(context, state, theme),
                style: TextButton.styleFrom(
                  foregroundColor: theme.primaryAccent,
                  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                child: const Text('See all'),
              ),
          ],
        ),
        const SizedBox(height: 4),
        if (state.previewPhrases.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              '${state.previewPhrases.length} lines detected',
              style: TextStyle(fontSize: 12, color: theme.mutedText)
            ),
          ),
        _buildPhrasesList(theme, state),
      ],
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

    return Container(
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.cardBorder),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.previewPhrases.length > 5 ? 5 : state.previewPhrases.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: theme.dividerColor),
        itemBuilder: (context, index) {
          final phrase = state.previewPhrases[index];
          return ListTile(
            dense: true,
            leading: Text(
              _formatTime(phrase.startTime), 
              style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: theme.mutedText)
            ),
            title: Text(
              phrase.originalPhrase ?? '', 
              style: TextStyle(fontSize: 13, color: theme.normalText)
            ),
          );
        },
      ),
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
