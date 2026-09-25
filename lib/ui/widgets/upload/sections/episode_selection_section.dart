import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/jimaku_files_provider.dart';
import '../../../../backend/database/dto/media_dto.dart';
import '../../../styles/additional_window_theme.dart';
import '../../../styles/app_colors.dart';
import '../../dialogs/app_bottom_sheet.dart';
import '../../dialogs/app_bottom_sheet_header.dart';
import '../../shared/app_text_button.dart';
import '../selectors/subtitle_method_selector.dart';
import '../components/sync_status_indicators.dart';
import '../components/sync_technical_details.dart';
import '../components/subtitle_sync_plaque.dart';
import '../../search/cloud/cloud_file_tile.dart';
import '../../search/cloud/cloud_group_tile.dart';
import 'subtitle_version_section.dart';
import 'subtitle_input_section.dart';
import 'subtitle_preview_list.dart';

class EpisodeSelectionSection extends HookConsumerWidget {
  const EpisodeSelectionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);
    final theme = AdditionalWindowTheme.of(context);
    final entry = ref.watchJimakuSelectedEntry() ?? ref.watchSelectedMetadataEntry();
    final isTechExpanded = useState(false);

    if (state.subtitleSource == SubtitleSource.none) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMethodHeader(theme, 'Custom Subtitle Attachment', Icons.upload_file_rounded),
          const SizedBox(height: 16),
          const SubtitleInputSection(showHeader: false),
          if (state.activeSelection != null) ...[
            const SizedBox(height: 24),
            _buildActiveSubtitleCard(context, ref, state, isTechExpanded),
          ],
        ],
      );
    }

    if (state.subtitleSource == SubtitleSource.ai) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMethodHeader(theme, 'Neural Audio Transcription', Icons.auto_awesome_rounded),
          const SizedBox(height: 16),
          if (state.activeSelection != null) ...[
            _buildAiTranscriptionConfig(context, ref, state, theme),
            const SizedBox(height: 24),
            _buildActiveSubtitleCard(context, ref, state, isTechExpanded),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEFF6FF), Color(0xFFF8FAFC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Transcription Ready',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Subtitles will be generated once you add the video. Please keep the app open and do not lock your phone as this process may take a while.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }

    final needsEntry = state.subtitleMethod == SubtitleMethod.quick ||
        state.subtitleMethod == SubtitleMethod.ai_scan ||
        (state.subtitleMethod == SubtitleMethod.manual && state.subtitleSource != SubtitleSource.local);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SubtitleMethodSelector(),
        const SizedBox(height: 24),

        if (needsEntry && entry == null)
          _buildEmptyState(theme, 'Match media in Step 2 to enable features here')
        else ...[
          _buildContentByMethod(context, ref, state, entry),
          const SizedBox(height: 24),
        ],

        if (state.isParsing) ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
          const SizedBox(height: 24),
        ],

        // НИЗ: однаковий для всіх методів
        if (state.activeSelection != null) ...[
          if (state.analyzedVersions.length > 1 || state.subtitleMethod == SubtitleMethod.ai_scan) ...[
            const SubtitleVersionSection(),
          ] else ...[
            _buildActiveSubtitleCard(context, ref, state, isTechExpanded),
          ],
        ],
      ],
    );
  }

  Widget _buildAiTranscriptionConfig(BuildContext context, WidgetRef ref, UploadState state, AdditionalWindowTheme theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.psychology_rounded, color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Whisper Neural Engine', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  Text('Automatic speech-to-text conversion', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Subtitles will be automatically generated by the AI neural network.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentByMethod(BuildContext context, WidgetRef ref, UploadState state, UnifiedMetadataDTO? entry) {
    switch (state.subtitleMethod) {
      case SubtitleMethod.manual: return _buildManualView(context, ref, state, entry);
      case SubtitleMethod.quick:  return _buildQuickView(context, ref, state, entry!);
      case SubtitleMethod.ai_scan: return _buildAiScanView(context, ref, state, entry!);
      case SubtitleMethod.video:  return _buildVideoView(context, state);
    }
  }

  // --- MANUAL VIEW: Folder Tree View ---
  Widget _buildManualView(BuildContext context, WidgetRef ref, UploadState state, UnifiedMetadataDTO? entry) {
    final theme = AdditionalWindowTheme.of(context);
    final jimakuId = entry?.jimakuId?.toString() ?? entry?.sourceId ?? '';
    final filesState = ref.watch(jimakuFilesProvider(jimakuId));
    
    if (filesState.isLoading) return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMethodHeader(theme, 'Select from Community', Icons.cloud_queue_rounded),
        const SizedBox(height: 12),
        if (filesState.rawFiles.isEmpty)
          _buildEmptyState(theme, 'No files found on Jimaku for this entry')
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filesState.files.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = filesState.files[index];
                if (item.isGroup) {
                  return CloudGroupTile(
                    group: item.group!,
                    onTap: () => ref.read(jimakuFilesProvider(jimakuId).notifier).toggleGroup(item.group!.name),
                  );
                } else {
                  final file = item.file!;
                  final isActive = state.manualSelection?.fileName == file.name;
                  final bool isSubItem = filesState.expandedGroups.any((g) => file.name.contains(g));
                  
                  return CloudFileTile(
                    file: file,
                    isActive: isActive,
                    onTap: () => ref.read(uploadProvider.notifier).selectManual(file),
                    isSubItem: isSubItem,
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  // --- QUICK VIEW: Episode Picker + Algorithm ---
  Widget _buildQuickView(BuildContext context, WidgetRef ref, UploadState state, UnifiedMetadataDTO entry) {
    final theme = AdditionalWindowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMethodHeader(theme, 'Auto-Match by Episode', Icons.bolt_rounded),
        const SizedBox(height: 12),
        _buildEpisodeGrid(context, ref, state, entry, (ep) => ref.read(uploadProvider.notifier).runQuickMatch(ep)),
      ],
    );
  }

  Widget _buildMatchedFileBanner(AdditionalWindowTheme theme, String fileName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.primaryAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.primaryAccent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, size: 14, color: theme.primaryAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Auto-matched: $fileName',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: theme.primaryAccent,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --- AI SCAN VIEW: Episode Picker + Batch Scan ---
  Widget _buildAiScanView(BuildContext context, WidgetRef ref, UploadState state, UnifiedMetadataDTO entry) {
    final theme = AdditionalWindowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMethodHeader(theme, 'Neural Episode Search', Icons.auto_awesome_rounded),
            if ((ref.watch(cloudSummaryProvider((SearchSourceKeys.jimaku, entry.sourceId)))?.episodes.length ?? entry.episodes ?? 0) > 12)
              AppTextButton(
                onPressed: () => _showAllEpisodesDialog(context, ref, state, entry, (ep) => ref.read(uploadProvider.notifier).runAiBatchMatch(ep)),
                text: 'See more',
              ),
          ],
        ),
        const SizedBox(height: 12),
        _buildEpisodeGrid(context, ref, state, entry, (ep) => ref.read(uploadProvider.notifier).runAiBatchMatch(ep), limit: 12),
        if (state.isEvaluatingBatch) ...[
          const SizedBox(height: 16),
          buildBatchProgress(state, theme),
        ],
      ],
    );
  }

  void _showAllEpisodesDialog(BuildContext context, WidgetRef ref, UploadState state, UnifiedMetadataDTO entry, Function(String) onSelected) {
    AppBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBottomSheetHeader(title: 'All Episodes'),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildEpisodeGrid(context, ref, state, entry, (ep) {
              Navigator.pop(context);
              onSelected(ep);
            }),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // --- VIDEO VIEW: Embedded Track ---
  Widget _buildVideoView(BuildContext context, UploadState state) {
    final theme = AdditionalWindowTheme.of(context);
    if (state.videoSelection == null) {
      return _buildEmptyState(theme, 'Select an embedded subtitle track in the player first');
    }
    return _buildMethodHeader(theme, 'Embedded Track', Icons.movie_filter_rounded);
  }

  // --- REUSABLE COMPONENTS ---

  Widget _buildEpisodeGrid(BuildContext context, WidgetRef ref, UploadState state, UnifiedMetadataDTO entry, Function(String) onSelected, {int? limit}) {
    final theme = AdditionalWindowTheme.of(context);
    final summary = ref.watch(cloudSummaryProvider((SearchSourceKeys.jimaku, entry.sourceId)));
    var episodes = summary?.episodes ?? List.generate(entry.episodes ?? 1, (i) => i + 1);
    
    if (limit != null && episodes.length > limit) {
      episodes = episodes.sublist(0, limit);
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: episodes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, 
        childAspectRatio: 2.2, 
        mainAxisSpacing: 10, 
        crossAxisSpacing: 10
      ),
      itemBuilder: (context, index) {
        final ep = episodes[index].toString();
        final isSelected = int.tryParse(state.episode ?? '') == int.tryParse(ep);
        
        return Material(
          color: isSelected ? const Color(0xFFEFF6FF).withValues(alpha: 0.7) : const Color(0xFFF1F5F9).withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => onSelected(ep),
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? theme.primaryAccent : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ep $ep', 
                    style: TextStyle(
                      color: isSelected ? theme.primaryAccent : AppColors.slate700, 
                      fontSize: 13, 
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    )
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.check_rounded, size: 14, color: theme.primaryAccent),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveSubtitleCard(BuildContext context, WidgetRef ref, UploadState state, ValueNotifier<bool> isExpanded) {
    final theme = AdditionalWindowTheme.of(context);
    final notifier = ref.read(uploadProvider.notifier);
    final sel = state.activeSelection!;

    return Column(
      children: [
        SubtitleSyncPlaque(
          version: sel,
          theme: theme,
          onDismiss: notifier.clearActiveSelection,
          onTap: () {
            // Можна додати швидкий перехід до прев'ю або іншу логіку
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => notifier.setStepIndex(0),
                icon: const Icon(Icons.play_circle_outline_rounded, size: 16),
                label: const Text('Video Preview'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  foregroundColor: AppColors.slate700,
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryAccent.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: state.isCheckingSync ? null : notifier.checkCurrentSync,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state.isCheckingSync)
                        const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      else
                      const SizedBox(width: 8),
                      Text(state.isCheckingSync ? 'Checking...' : 'Check Sync', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      if (!state.isCheckingSync) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('AI', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (state.syncConfidence > 0 || state.isCheckingSync) ...[
          const SizedBox(height: 16),
          ...buildTechDetails(
            context,
            state,
            theme,
            notifier,
            isExpanded,
            currentOffset: state.suggestedOffset ?? state.activeSelection?.offset,
          ),
        ],
      ],
    );
  }

  Widget _buildMethodHeader(AdditionalWindowTheme theme, String title, IconData icon) {
    return Row(children: [Icon(icon, size: 16, color: theme.primaryAccent), const SizedBox(width: 10), Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900))]);
  }

  Widget _buildEmptyState(AdditionalWindowTheme theme, String message) {
    return Container(padding: const EdgeInsets.all(20), child: Text(message, style: TextStyle(color: theme.mutedText, fontSize: 12)));
  }
}
