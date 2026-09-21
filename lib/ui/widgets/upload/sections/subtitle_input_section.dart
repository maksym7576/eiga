import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import '../../../styles/additional_window_theme.dart';
import '../components/upload_drop_box.dart';

class SubtitleInputSection extends HookConsumerWidget {
  final bool showHeader;
  const SubtitleInputSection({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);

    if (state.subtitleSource != SubtitleSource.local && state.subtitleSource != SubtitleSource.none) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          _buildMethodHeader(theme, 'Subtitle Configuration', Icons.edit_note_rounded),
          const SizedBox(height: 12),
        ],
        _buildMainContent(context, ref),
      ],
    );
  }

  Widget _buildMethodHeader(AdditionalWindowTheme theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.primaryAccent),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: theme.normalText,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);

    return Column(
      children: [
        UploadDropBox(
          onTap: notifier.pickSubtitle,
          title: 'Upload Subtitle File',
          subtitle: 'Tap to add the subtitles',
          filePath: state.subtitlePath,
          icon: Icons.subtitles_outlined,
        ),
        if (state.availableStreams.length > 1) ...[
          const SizedBox(height: 12),
          _buildStreamSelector(context, ref, state),
        ],
      ],
    );
  }

  Widget _buildStreamSelector(BuildContext context, WidgetRef ref, UploadState state) {
    final theme = AdditionalWindowTheme.of(context);
    final notifier = ref.read(uploadProvider.notifier);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.cardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.selectedStreamKey,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          items: state.availableStreams.keys.map((key) {
            return DropdownMenuItem(
              value: key,
              child: Text(key, style: TextStyle(fontSize: 12, color: theme.normalText, fontWeight: FontWeight.w600)),
            );
          }).toList(),
          onChanged: (val) => val != null ? notifier.selectSubtitleStream(val) : null,
        ),
      ),
    );
  }
}
