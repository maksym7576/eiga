import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/search_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../dialogs/app_bottom_sheet.dart';
import '../shared/upload_drop_box.dart';
import 'package:eiga/ui/widgets/shared/app_section_card.dart';
import 'jimaku_files_sheet.dart';

class SubtitleInputSection extends ConsumerWidget {
  const SubtitleInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);
    final selectedJimaku = ref.watchJimakuSelectedEntry();

    if (state.subtitleSource == SubtitleSource.jimaku) {
      if (selectedJimaku == null) return const SizedBox.shrink();
      return _buildFilesCard(context, ref, theme, state, selectedJimaku);
    }

    // Local source redesign to match Video adding style
    return UploadDropBox(
      onTap: notifier.pickSubtitle,
      title: 'Upload Subtitle File',
      subtitle: 'Tap to add the subtitles',
      filePath: state.subtitlePath,
      icon: Icons.subtitles_outlined,
    );
  }

  Widget _buildFilesCard(BuildContext context, WidgetRef ref, AdditionalWindowTheme theme, UploadState state, dynamic entry) {
    final hasFile = state.subtitlePath != null;
    final isJimaku = state.subtitleSource == SubtitleSource.jimaku;

    return AppSectionCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _openJimakuFiles(context, entry),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.brandBlue50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isJimaku ? Icons.tune_rounded : Icons.folder_shared_outlined, 
                      size: 16, 
                      color: theme.primaryAccent
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isJimaku ? 'Subtitle Selection' : 'Selected Subtitles',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: theme.normalText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          isJimaku ? 'Choose release group or track' : 'Locally provided subtitle file',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: theme.mutedText),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 16, color: theme.mutedText.withValues(alpha: 0.5)),
                ],
              ),
              if (hasFile) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.description_outlined, size: 14, color: theme.primaryAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          p.basename(state.subtitlePath!),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: theme.normalText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Text(
                          'Change',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10, color: Color(0xFF475569)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _openJimakuFiles(BuildContext context, dynamic entry) {
    AppBottomSheet.show(
      context: context,
      heightFactor: 0.88,
      child: JimakuFilesSheet(entry: entry),
    );
  }
}
