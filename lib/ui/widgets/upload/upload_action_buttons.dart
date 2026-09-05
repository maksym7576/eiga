import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';
import '../shared/app_action_button.dart';

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
                child: AppActionButton(
                  onPressed: () {
                    notifier.reset();
                    Navigator.pop(context);
                  },
                  text: 'Cancel',
                  type: AppActionButtonType.outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: AppActionButton(
                  onPressed: canAdd ? () => _onSave(context, notifier) : null,
                  text: 'Add Video',
                  isLoading: state.isSaving,
                  icon: const Icon(Icons.play_arrow_rounded, size: 16, color: AppColors.brandBlue),
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
              color: AppColors.slate200,
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
