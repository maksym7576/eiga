import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:eiga/ui/widgets/dialogs/app_bottom_sheet.dart';
import 'package:eiga/ui/widgets/search/jimaku/jimaku_subtitle_source.dart';
import 'package:eiga/ui/widgets/search/wyzie/wyzie_subtitle_source.dart';
import 'package:eiga/ui/widgets/shared/app_text_field.dart';
import 'package:eiga/ui/widgets/shared/app_text_button.dart';

import 'sync_preview_sheet.dart';
import 'sync_status_indicators.dart';

class EpisodeSelectionSection extends ConsumerWidget {
  const EpisodeSelectionSection({super.key});

  void _showPreview(BuildContext context, UploadState state) {
    AppBottomSheet.show(
      context: context,
      heightFactor: 0.9,
      child: SyncPreviewSheet(
        videoPath: state.videoPath!,
        phrases: state.previewPhrases,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);
    final subtitleSource = ref.watch(uploadProvider.select((s) => s.subtitleSource));
    
    final selectedEntry = subtitleSource == SubtitleSource.local
        ? ref.watchAniListSelectedEntry()
        : (subtitleSource == SubtitleSource.jimaku ? ref.watchJimakuSelectedEntry() : ref.watchWyzieSelectedEntry());

    if (selectedEntry == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: theme.mutedText),
            const SizedBox(width: 10),
            Text(
              'Match media in step 2 to select episodes',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.mutedText,
              ),
            ),
          ],
        ),
      );
    }

    int? epCount;
    List<int> episodes = const [];

    if (subtitleSource == SubtitleSource.local) {
      final aniListData = ref.watch(aniListProvider).value;
      final displayData = (aniListData != null && aniListData.sourceId == selectedEntry.sourceId) ? aniListData : selectedEntry;
      epCount = displayData.episodes;
    } else {
      final id = selectedEntry.sourceId;
      if (subtitleSource == SubtitleSource.jimaku) {
        final idInt = int.tryParse(id);
        if (idInt != null) {
          final summary = ref.watch(jimakuSummaryProvider(idInt));
          epCount = summary?.episodeCount;
          episodes = summary?.episodes ?? const [];
        }
      } else if (subtitleSource == SubtitleSource.wyzie) {
        final summary = ref.watch(wyzieSummaryProvider(id));
        epCount = summary?.episodeCount;
        episodes = summary?.episodes ?? const [];
      }
    }

    final visibleEpisodes = episodes.length > 12 ? episodes.take(12).toList() : episodes;
    final hasMoreEpisodes = episodes.length > 12;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Episode',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: theme.normalText,
                ),
              ),
              if ((subtitleSource == SubtitleSource.jimaku || subtitleSource == SubtitleSource.wyzie) && epCount != null && episodes.isNotEmpty && hasMoreEpisodes)
                AppTextButton(
                  onPressed: () => _showAllEpisodes(context, ref, episodes, selectedEntry, subtitleSource),
                  text: 'See all $epCount',
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          if ((subtitleSource == SubtitleSource.jimaku || subtitleSource == SubtitleSource.wyzie) && episodes.isNotEmpty) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleEpisodes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.2,
              ),
              itemBuilder: (context, index) {
                final episode = visibleEpisodes[index];
                return _buildEpisodeButton(
                   context, 
                   ref,
                   episode, 
                   selectedEntry,
                   subtitleSource,
                   isSelected: ref.watch(uploadProvider.select((s) => s.episode)) == episode.toString(),
                 );
              },
            ),
          ] else if (subtitleSource == SubtitleSource.local) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    onChanged: (val) => ref.read(uploadProvider.notifier).setEpisode(val),
                    keyboardType: TextInputType.number,
                    hintText: 'Episode number (Optional)',
                    controller: TextEditingController(text: ref.read(uploadProvider).episode),
                  ),
                ),
                if (ref.watch(uploadProvider).subtitlePath != null) ...[
                  const SizedBox(width: 12),
                  _LocalSyncStatusIndicator(),
                ],
              ],
            ),
          ] else ...[
            Text(
              'Analyzing files...',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: theme.mutedText),
            ),
          ],
          
          const SizedBox(height: 24),

          Row(
            children: [
              Text(
                'Sync subtitle',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: theme.normalText,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              if (state.previewPhrases.isNotEmpty)
                AppTextButton(
                  onPressed: () => _showPreview(context, state),
                  text: 'Manual Preview',
                ),
              if (state.isCheckingSync || state.isEvaluatingBatch) ...[
                const SizedBox(width: 8),
              ],
            ],
          ),
          if (state.isEvaluatingBatch || state.isCheckingSync) ...[
            const SizedBox(height: 16),
            buildBatchProgress(state, theme),
          ],
          
          if (!state.isEvaluatingBatch && !state.isCheckingSync && state.analyzedVersions.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'No versions analyzed yet',
                style: TextStyle(fontSize: 11, color: theme.mutedText, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEpisodeButton(BuildContext context, WidgetRef ref, int episode, UnifiedMetadataDTO entry, SubtitleSource source, {bool isSelected = false}) {
    final theme = AdditionalWindowTheme.of(context);
    
    return InkWell(
      onTap: () {
        if (source == SubtitleSource.jimaku) {
          JimakuSubtitleSource().selectEpisodeSubtitle(entry, episode, ref);
        } else {
          WyzieSubtitleSource().selectEpisodeSubtitle(entry, episode, ref);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryAccent : AppColors.slate100,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [
            BoxShadow(
              color: theme.primaryAccent.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            'Ep $episode',
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.slate700,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void _showAllEpisodes(BuildContext context, WidgetRef ref, List<int> episodes, UnifiedMetadataDTO entry, SubtitleSource source) {
    final theme = AdditionalWindowTheme.of(context);
    final selectedEp = ref.watch(uploadProvider.select((state) => state.episode));

    AppBottomSheet.show(
      context: context,
      heightFactor: 0.8,
      child: Builder(
        builder: (sheetContext) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppBottomSheetHeader(
              title: 'Select Episode',
            ),
            const SizedBox(height: 8),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 0, 12, 20),
                itemCount: episodes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.2,
                ),
                itemBuilder: (context, index) {
                  final episode = episodes[index];
                  final isSelected = selectedEp == episode.toString();
                  return InkWell(
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      if (source == SubtitleSource.jimaku) {
                        JimakuSubtitleSource().selectEpisodeSubtitle(entry, episode, ref);
                      } else {
                        WyzieSubtitleSource().selectEpisodeSubtitle(entry, episode, ref);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? theme.primaryAccent : AppColors.slate100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Ep $episode',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.slate700,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalSyncStatusIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);

    if (state.isCheckingSync) {
      return const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5));
    }

    IconData icon;
    Color color;

    switch (state.syncStatus) {
      case SyncMatchStatus.perfect:
        icon = Icons.check_circle_rounded;
        color = AppColors.successText;
        break;
      case SyncMatchStatus.offset:
        icon = Icons.warning_amber_rounded;
        color = AppColors.warningText;
        break;
      case SyncMatchStatus.mismatch:
        icon = Icons.error_outline_rounded;
        color = Colors.redAccent;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}
