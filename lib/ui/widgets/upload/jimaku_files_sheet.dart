import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/jimaku_files_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/search/jimaku/jimaku_subtitle_source.dart';
import 'package:eiga/ui/widgets/dialogs/app_bottom_sheet.dart';

class JimakuFilesSheet extends ConsumerWidget {
  final UnifiedMetadataDTO entry;

  const JimakuFilesSheet({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final id = int.parse(entry.sourceId);
    final state = ref.watch(jimakuFilesProvider(id));
    
    final selectedResult = ref.watch(selectedResultProvider(SearchSourceKeys.jimaku));
    final isResolving = ref.watch(isResolvingProvider(SearchSourceKeys.jimaku));
    
    final source = JimakuSubtitleSource();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppBottomSheetHeader(
          title: 'Select subtitles',
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.files.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final file = state.files[index];
                final bool isActive = selectedResult is JimakuFileOrGroupDTO &&
                    source.fileId(file) == source.fileId(selectedResult);
                    
                return source.buildFileCard(file, isActive, () {
                  if (!file.isGroup) {
                    ref.read(selectedResultProvider(SearchSourceKeys.jimaku).notifier).state = file;
                  }
                });
              },
            ),
          ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Row(
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
        ),
      ],
    );
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref, JimakuSubtitleSource source) async {
    final selected = ref.read(selectedResultProvider(SearchSourceKeys.jimaku));
    if (selected == null) return;

    ref.read(isResolvingProvider(SearchSourceKeys.jimaku).notifier).state = true;
    try {
      final result = await source.resolve(selected, ref);
      ref.read(uploadProvider.notifier).handleSubtitleSelected(result);
      if (context.mounted) Navigator.pop(context);
    } finally {
      ref.read(isResolvingProvider(SearchSourceKeys.jimaku).notifier).state = false;
    }
  }
}
