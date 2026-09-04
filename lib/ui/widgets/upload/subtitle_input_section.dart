import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/search_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../dialogs/app_bottom_sheet.dart';
import '../shared/upload_drop_box.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
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
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                isJimaku ? 'Manual Subtitle Selection' : 'Selected Subtitles',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: theme.normalText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: theme.brandBlue50,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: theme.brandBlue100),
                              ),
                              child: Text(
                                isJimaku ? 'Manual' : 'Local',
                                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: theme.primaryAccent),
                              ),
                            ),
                          ],
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
                  if (isJimaku)
                    TextButton(
                      onPressed: () => _openJimakuFiles(context, entry),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.primaryAccent,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                      ),
                      child: const Row(
                        children: [
                          Text('Browse'),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, size: 10),
                        ],
                      ),
                    ),
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
                      TextButton(
                        onPressed: isJimaku 
                            ? () => _openJimakuFiles(context, entry)
                            : () => ref.read(uploadProvider.notifier).pickSubtitle(),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF475569),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
                        ),
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
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
