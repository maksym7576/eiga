import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/search_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';
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
    final fileName = hasFile ? p.basename(state.subtitlePath!) : 'No file selected';

    return AppSectionCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _openJimakuFiles(context, entry),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              // Mockup Leading Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.slate100),
                ),
                child: const Icon(
                  Icons.file_open_outlined, 
                  size: 20, 
                  color: AppColors.slate700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Subtitle',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fileName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.slate400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded, 
                size: 22, 
                color: AppColors.slate300,
              ),
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
