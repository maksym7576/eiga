import 'package:flutter/material.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';
import '../dialogs/app_bottom_sheet.dart';
import 'sync_technical_details.dart';
import '../shared/app_selection_tile.dart';

/// Tappable card showing the currently selected subtitle version, its match
/// confidence, and (optional) technical details.
Widget buildVersionSelectorCard(
  BuildContext context,
  UploadState state,
  AdditionalWindowTheme theme,
  UploadNotifier notifier, {
  ValueNotifier<bool>? isExpanded,
  VoidCallback? onTap,
  bool showTechDetails = true,
}) {
  final bestVersion = state.analyzedVersions.isNotEmpty ? state.analyzedVersions.first : null;
  
  // Try to find matching analyzed version
  AnalyzedSubtitle? selectedVersion;
  if (state.analyzedVersions.isNotEmpty) {
    selectedVersion = state.analyzedVersions.firstWhere(
      (v) => v.fileName == state.subtitleFileName,
      orElse: () => bestVersion!,
    );
  }

  if (selectedVersion == null && state.analyzedVersions.isEmpty) {
    return const SizedBox.shrink();
  }

  final fileName = selectedVersion?.fileName ?? state.subtitleFileName ?? 'Select version...';
  final isRecommended = selectedVersion != null && selectedVersion == bestVersion && bestVersion!.confidence > 0.4;
  final confidence = selectedVersion?.confidence ?? 0.0;
  final hasMatch = selectedVersion != null && confidence > 0;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppSelectionTile(
        title: fileName,
        subtitle: isRecommended ? 'Recommended match' : (hasMatch ? 'Manual selection' : 'Checking...'),
        isSelected: true,
        isExpanded: false,
        showToggle: true,
        onTap: onTap ?? () => showVersionSelectionDialog(context, state, theme, notifier),
      ),
      if (showTechDetails && selectedVersion != null && isExpanded != null) ...[
        buildTechDetails(
          state,
          theme,
          notifier,
          isExpanded,
          currentOffset: selectedVersion.offset,
        ),
      ],
    ],
  );
}

/// Bottom sheet listing every analyzed subtitle version, ordered by
/// confidence, letting the user pick one.
void showVersionSelectionDialog(
  BuildContext context,
  UploadState state,
  AdditionalWindowTheme theme,
  UploadNotifier notifier,
) {
  AppBottomSheet.show(
    context: context,
    heightFactor: 0.6,
    child: Builder(
      builder: (sheetContext) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBottomSheetHeader(
            title: 'Select Subtitle Version',
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.analyzedVersions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final version = state.analyzedVersions[index];
                final isSelected = version.fileName == state.subtitleFileName;
                final isBest = index == 0 && version.confidence > 0.4;

                return VersionTile(
                  version: version,
                  isSelected: isSelected,
                  isBest: isBest,
                  theme: theme,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    notifier.selectVersion(version);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

/// Single row inside the version-selection bottom sheet.
class VersionTile extends StatelessWidget {
  final AnalyzedSubtitle version;
  final bool isSelected;
  final bool isBest;
  final AdditionalWindowTheme theme;
  final VoidCallback onTap;

  const VersionTile({
    super.key,
    required this.version,
    required this.isSelected,
    required this.isBest,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : theme.cardBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.primaryAccent : theme.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          version.fileName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: theme.normalText,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isBest) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.brandBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Recommended',
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.brandBlue),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Match Confidence: ${(version.confidence * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: theme.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
