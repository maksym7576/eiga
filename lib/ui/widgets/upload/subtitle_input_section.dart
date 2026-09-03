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

      final hasFile = state.subtitlePath != null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _openJimakuFiles(context, selectedJimaku),
              icon: Icon(Icons.tune_rounded, size: 20, color: theme.primaryAccent),
              label: Text(
                'Advanced Subtitle Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                  color: theme.normalText,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.primaryAccent, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                backgroundColor: theme.primaryAccent.withValues(alpha: 0.05),
              ),
            ),
          ),
          if (hasFile) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.primaryAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primaryAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.description_outlined, size: 18, color: theme.primaryAccent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      p.basename(state.subtitlePath!),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.normalText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.check_circle, size: 16, color: theme.primaryAccent),
                ],
              ),
            ),
          ],
        ],
      );
    }

    // Local source using shared UploadDropBox
    return UploadDropBox(
      onTap: notifier.pickSubtitle,
      title: 'Upload Subtitle File',
      subtitle: '.srt, .ass, .vtt',
      filePath: state.subtitlePath,
      icon: Icons.subtitles_outlined,
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
