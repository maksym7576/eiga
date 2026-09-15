import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/jimaku_files_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/wyzie_files_provider.dart';
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
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);
    final selectedJimaku = ref.watchJimakuSelectedEntry();
    final selectedWyzie = ref.watchWyzieSelectedEntry();

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

    if (state.subtitleSource == SubtitleSource.wyzie) {
      if (selectedWyzie == null) return const SizedBox.shrink();
      return _buildPickerCard(
        context,
        title: state.subtitleFileName ?? 'Select Wyzie version...',
        subtitle: 'Alternative cloud version',
        onTap: () {
          AppBottomSheet.show(
            context: context,
            child: CloudSubtitleFilesSheet(
              entry: selectedWyzie,
              title: 'Select Wyzie subtitles',
              searchKey: SearchSourceKeys.wyzie,
              stateProvider: wyzieFilesProvider(selectedWyzie.sourceId),
              source: CloudSubtitleSource(SearchSourceKeys.wyzie),
            ),
          );
        },
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
