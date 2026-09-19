import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/jimaku_files_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import '../../../styles/additional_window_theme.dart';
import '../../dialogs/app_bottom_sheet.dart';
import '../../search/cloud/cloud_subtitle_source.dart';
import '../sheets/cloud_subtitle_files_sheet.dart';
import '../components/upload_drop_box.dart';
import '../../shared/app_selection_tile.dart';

class SubtitleInputSection extends HookConsumerWidget {
  const SubtitleInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);
    final selectedJimaku = ref.watchJimakuSelectedEntry();

    if (state.subtitleSource == SubtitleSource.jimaku) {
      if (selectedJimaku == null) return const SizedBox.shrink();
      return _buildPickerCard(
        context,
        title: state.subtitleFileName ?? 'Select Jimaku version...',
        subtitle: 'Community cloud version',
        onTap: () {
          AppBottomSheet.show(
            context: context,
            child: CloudSubtitleFilesSheet(
              entry: selectedJimaku,
              title: 'Select subtitles',
              searchKey: SearchSourceKeys.jimaku,
              stateProvider: jimakuFilesProvider(selectedJimaku.sourceId),
              source: CloudSubtitleSource(SearchSourceKeys.jimaku),
            ),
          );
        },
      );
    }

    if (state.subtitleSource == SubtitleSource.ai) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.primaryAccent.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.primaryAccent.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: theme.primaryAccent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Transcription Enabled',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: theme.primaryAccent,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Subtitles will be generated automatically.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: theme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 14, color: theme.mutedText),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please ensure you select the correct original language in Step 4.',
                      style: TextStyle(fontSize: 10, color: theme.mutedText, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return UploadDropBox(
      onTap: notifier.pickSubtitle,
      title: 'Upload Subtitle File',
      subtitle: 'Tap to add the subtitles',
      filePath: state.subtitlePath,
      icon: Icons.subtitles_outlined,
    );
  }

  Widget _buildPickerCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = AdditionalWindowTheme.of(context);
    return AppSelectionTile(
      title: title,
      subtitle: subtitle,
      isSelected: false,
      isExpanded: false,
      onTap: onTap,
      trailing: Icon(
        Icons.open_in_new_rounded,
        size: 18,
        color: theme.mutedText,
      ),
    );
  }
}
