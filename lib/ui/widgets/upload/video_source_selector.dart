import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/search_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import '../shared/app_selection_tile.dart';

class VideoSourceSelector extends ConsumerWidget {
  const VideoSourceSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final isExpanded = ref.watch(isVideoSourceSelectorExpandedProvider);
    final selected = ref.watch(uploadProvider.select((s) => s.videoSource));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Video Source:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: theme.normalText,
              letterSpacing: -0.2,
            ),
          ),
        ),
        
        AnimatedSize(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isExpanded
              ? Column(
                  key: const ValueKey('expanded'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTile(ref, VideoSource.file, isExpanded),
                  ],
                )
              : _buildTile(ref, selected, isExpanded, showToggle: true),
        ),
      ],
    );
  }

  Widget _buildTile(WidgetRef ref, VideoSource type, bool isExpanded, {bool showToggle = false}) {
    final selected = ref.watch(uploadProvider.select((s) => s.videoSource));
    final isSelected = selected == type;

    return AppSelectionTile(
      title: _getSourceTitle(type),
      subtitle: _getSourceSubtitle(type),
      icon: _getSourceIcon(type),
      isSelected: isSelected,
      isExpanded: isExpanded,
      showToggle: showToggle,
      onTap: () {
        if (!isExpanded) {
          ref.read(isVideoSourceSelectorExpandedProvider.notifier).state = true;
        } else {
          ref.read(uploadProvider.notifier).setVideoSource(type);
          ref.read(isVideoSourceSelectorExpandedProvider.notifier).state = false;
        }
      },
    );
  }

  String _getSourceTitle(VideoSource type) {
    switch (type) {
      case VideoSource.file: return 'Local File';
    }
  }

  String _getSourceSubtitle(VideoSource type) {
    switch (type) {
      case VideoSource.file: return '';
    }
  }

  IconData _getSourceIcon(VideoSource type) {
    switch (type) {
      case VideoSource.file: return Icons.file_present_rounded;
    }
  }
}
