import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/wyzie_files_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/search/wyzie/wyzie_subtitle_source.dart';

class WyzieFilesSheet extends ConsumerWidget {
  final UnifiedMetadataDTO entry;

  const WyzieFilesSheet({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(wyzieFilesProvider(entry.sourceId));
    
    final selectedResult = ref.watch(selectedResultProvider(SearchSourceKeys.wyzie));
    final isResolving = ref.watch(isResolvingProvider(SearchSourceKeys.wyzie));
    
    final source = WyzieSubtitleSource();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Select Wyzie subtitles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: theme.normalText,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, color: theme.mutedText),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.files.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(child: Text('No files found')),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(right: 8),
                itemCount: state.files.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final file = state.files[index];
                  final bool isActive = selectedResult is JimakuFileOrGroupDTO &&
                      source.fileId(file) == source.fileId(selectedResult);
                      
                  return source.buildFileCard(file, isActive, () {
                    if (!file.isGroup) {
                      ref.read(selectedResultProvider(SearchSourceKeys.wyzie).notifier).state = file;
                    }
                  });
                },
              ),
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.normalText,
                    side: BorderSide(color: theme.cardBorder),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [
                        theme.primaryAccent,
                        theme.primaryAccent.withValues(alpha: 0.82)
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryAccent.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: selectedResult == null || isResolving ? null : () => _confirm(context, ref, source),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: theme.backgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: isResolving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Add Subtitles',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.1,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref, WyzieSubtitleSource source) async {
    final selected = ref.read(selectedResultProvider(SearchSourceKeys.wyzie));
    if (selected == null) return;

    ref.read(isResolvingProvider(SearchSourceKeys.wyzie).notifier).state = true;
    try {
      final result = await source.resolve(selected, ref);
      ref.read(uploadProvider.notifier).handleSubtitleSelected(result);
      if (context.mounted) Navigator.pop(context);
    } finally {
      ref.read(isResolvingProvider(SearchSourceKeys.wyzie).notifier).state = false;
    }
  }
}
