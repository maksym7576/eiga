import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/search_provider.dart';
import '../../styles/additional_window_theme.dart';

class UploadActionButtons extends ConsumerWidget {
  const UploadActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);
    
    final bool canAdd = state.videoPath != null && state.subtitlePath != null && !state.isSaving;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Reset all relevant providers
              ref.invalidate(uploadProvider);
              ref.invalidate(videoPathProvider);
              
              // Clear selection
              ref.read(selectedEntryProvider(SearchSourceKeys.jimaku).notifier).state = null;
              ref.read(selectedEntryProvider(SearchSourceKeys.anilist).notifier).state = null;
              ref.read(selectedResultProvider(SearchSourceKeys.jimaku).notifier).state = null;
              ref.read(selectedResultProvider(SearchSourceKeys.anilist).notifier).state = null;
              
              // Clear search results list
              ref.read(searchResultsProvider(SearchSourceKeys.jimaku).notifier).state = [];
              ref.read(searchResultsProvider(SearchSourceKeys.anilist).notifier).state = [];
              ref.read(jimakuSearchFullResultsProvider.notifier).state = [];
              
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: canAdd ? () => _onSave(context, notifier) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.addButtonBackground,
              foregroundColor: theme.addButtonText,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: state.isSaving 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Add Video', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Future<void> _onSave(BuildContext context, UploadNotifier notifier) async {
    final success = await notifier.saveVideo();
    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video added successfully!')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add video')));
      }
    }
  }
}
