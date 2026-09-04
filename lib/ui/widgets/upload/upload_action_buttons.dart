import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/search_provider.dart';
import '../../styles/additional_window_theme.dart';

import '../../../providers/videoComponentsProvider.dart';

class UploadActionButtons extends ConsumerWidget {
  const UploadActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);
    final languages = ref.watch(languageProvider);
    
    final bool canAdd = state.videoPath != null && 
                       state.subtitlePath != null && 
                       languages.original != null && 
                       languages.target != null &&
                       !state.isSaving;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    notifier.reset();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    foregroundColor: const Color(0xFF334155),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: canAdd ? () => _onSave(context, notifier) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A), // Slate 900
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  child: state.isSaving 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 16, color: Color(0xFF3B66F5)),
                          SizedBox(width: 8),
                          Text('Add Video'),
                        ],
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // iOS Home Indicator simulation
          Container(
            width: 120,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave(BuildContext context, UploadNotifier notifier) async {
    final success = await notifier.saveVideo();
    if (context.mounted) {
      if (success) {
        notifier.reset();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video added successfully!')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add video')));
      }
    }
  }
}
