import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/search_provider.dart';
import '../../../providers/ui/dto_providers.dart';
import 'package:eiga/backend/database/dto/jimaku_dto.dart';
import 'package:eiga/backend/database/dto/anilist_dto.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';
import '../dialogs/app_bottom_sheet.dart';
import '../search/jimaku/jimaku_subtitle_source.dart';
import '../shared/app_section_card.dart';
import '../shared/app_text_field.dart';
import '../shared/app_text_button.dart';

class EpisodeSelectionSection extends ConsumerWidget {
  const EpisodeSelectionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final subtitleSource = ref.watch(uploadProvider.select((s) => s.subtitleSource));
    
    final selectedEntry = subtitleSource == SubtitleSource.local
        ? ref.watchAniListSelectedEntry()
        : ref.watchJimakuSelectedEntry();

    if (selectedEntry == null) {
      return AppSectionCard(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: theme.mutedText),
            const SizedBox(width: 10),
            Text(
              'Match media in step 3 to select episodes',
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
      final data = selectedEntry as AniListDataDTO;
      final displayData = (aniListData != null && aniListData.id == data.id) ? aniListData : data;
      epCount = displayData.episodes;
    } else {
      final data = selectedEntry as JimakuDataDTO;
      final summary = ref.watch(jimakuSummaryProvider(data.id));
      epCount = summary?.episodeCount;
      episodes = summary?.episodes ?? const [];
    }

    final visibleEpisodes = episodes.length > 12 ? episodes.take(12).toList() : episodes;
    final hasMoreEpisodes = episodes.length > 12;

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtitleSource == SubtitleSource.local ? 'Episode Details' : 'Select Episode to Sync',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: theme.normalText,
                ),
              ),
              if (subtitleSource == SubtitleSource.jimaku && epCount != null && episodes.isNotEmpty && hasMoreEpisodes)
                AppTextButton(
                  onPressed: () => _showAllEpisodes(context, ref, episodes, selectedEntry as JimakuDataDTO),
                  text: 'See all $epCount',
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (subtitleSource == SubtitleSource.jimaku && episodes.isNotEmpty) ...[
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
                   selectedEntry as JimakuDataDTO,
                   isSelected: ref.watch(uploadProvider.select((s) => s.episode)) == episode.toString(),
                 );
              },
            ),
          ] else if (subtitleSource == SubtitleSource.local) ...[
            const SizedBox(height: 4),
            AppTextField(
              onChanged: (val) => ref.read(uploadProvider.notifier).setEpisode(val),
              keyboardType: TextInputType.number,
              hintText: 'Episode number (Optional)',
            ),
          ] else ...[
            Text(
              'Analyzing files...',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: theme.mutedText),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEpisodeButton(BuildContext context, WidgetRef ref, int episode, JimakuDataDTO entry, {bool isSelected = false}) {
    final theme = AdditionalWindowTheme.of(context);
    
    return InkWell(
      onTap: () => JimakuSubtitleSource().selectEpisodeSubtitle(entry, episode, ref),
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

  void _showAllEpisodes(BuildContext context, WidgetRef ref, List<int> episodes, JimakuDataDTO entry) {
    final theme = AdditionalWindowTheme.of(context);
    final selectedEp = ref.watch(uploadProvider.select((state) => state.episode));

    AppBottomSheet.show(
      context: context,
      heightFactor: 0.8,
      child: Builder(
        builder: (sheetContext) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Episode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: theme.normalText,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    icon: Icon(Icons.close_rounded, color: theme.mutedText),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(right: 8, bottom: 20),
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
                        JimakuSubtitleSource().selectEpisodeSubtitle(entry, episode, ref);
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
      ),
    );
  }
}
