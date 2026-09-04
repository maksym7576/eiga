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
        Container(
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
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: const Color(0xFFD1FAE5)),
                      ),
                      child: const Text(
                        'Sync OK',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF059669)),
                      ),
                    ),
                  ],
                ),
              ),
              _buildPhrasesList(theme, state),
              if (state.previewPhrases.length > 5)
                GestureDetector(
                  onTap: () => _showAllPhrases(context, state, theme),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      'See all phrases',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: theme.primaryAccent),
                    ),
                  ),
                ),
            ],
          ),
        ),
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
