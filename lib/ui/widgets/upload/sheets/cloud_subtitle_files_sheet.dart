import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/cloud_files_state.dart';
import 'package:eiga/ui/widgets/dialogs/app_bottom_sheet.dart';
import 'package:eiga/ui/widgets/dialogs/app_sheet_footer.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';

class CloudSubtitleFilesSheet extends ConsumerWidget {
  final UnifiedMetadataDTO entry;
  final String title;
  final String searchKey;
  final dynamic stateProvider; // Using dynamic to avoid ProviderListenable issues
  final SearchSource source;

  const CloudSubtitleFilesSheet({
    super.key,
    required this.entry,
    required this.title,
    required this.searchKey,
    required this.stateProvider,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider) as CloudFilesState;
    
    final selectedResult = ref.watch(selectedResultProvider(searchKey));
    final isResolving = ref.watch(isResolvingProvider(searchKey));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBottomSheetHeader(
          title: title,
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
                    ref.read(selectedResultProvider(searchKey).notifier).state = file;
                  }
                });
              },
            ),
          ),
        const SizedBox(height: 24),
        AppSheetFooter(
          confirmText: 'Add Subtitles',
          isResolving: isResolving,
          onCancel: () => Navigator.pop(context),
          onConfirm: selectedResult == null ? null : () => _confirm(context, ref),
        ),
      ],
    );
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final selected = ref.read(selectedResultProvider(searchKey));
    if (selected == null) return;

    ref.read(isResolvingProvider(searchKey).notifier).state = true;
    try {
      final result = await source.resolve(selected, ref);
      ref.read(uploadProvider.notifier).handleSubtitleSelected(result);
      if (context.mounted) Navigator.pop(context);
    } finally {
      ref.read(isResolvingProvider(searchKey).notifier).state = false;
    }
  }
}
