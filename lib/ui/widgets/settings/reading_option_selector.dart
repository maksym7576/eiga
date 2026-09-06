import 'package:flutter/material.dart';
import '../../../providers/services/reading_type_provider.dart';
import '../../styles/additional_window_theme.dart';

abstract class ReadingTypeActions {
  void updateMainOption(String option);
  void updateAdditionalOption(String? option);
  void updateShowTranslation(bool value);
}

class ReadingOptionSelector extends StatelessWidget {
  final ReadingTypeState state;
  final ReadingTypeActions actions;

  const ReadingOptionSelector({
    super.key,
    required this.state,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary Section
          _buildSectionHeader(
            theme: theme,
            title: 'Primary Subtitle',
            subtitle: 'This will be the main original text shown.',
          ),
          const SizedBox(height: 8),
          _buildOptionGroup(
            theme: theme,
            children: state.availableOptions.map((opt) {
              return _ReadingOptionTile(
                label: state.getLabel(opt),
                isSelected: state.mainOption == opt,
                onTap: () => actions.updateMainOption(opt),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Secondary Section
          _buildSectionHeader(
            theme: theme,
            title: 'Secondary Subtitle',
            subtitle: 'Annotation text shown above the primary.',
          ),
          const SizedBox(height: 8),
          _buildOptionGroup(
            theme: theme,
            children: [
              _ReadingOptionTile(
                label: 'NONE',
                isSelected: state.additionalOption == null,
                onTap: () => actions.updateAdditionalOption(null),
              ),
              ...state.availableOptions.map((opt) {
                return _ReadingOptionTile(
                  label: state.getLabel(opt),
                  isSelected: state.additionalOption == opt,
                  onTap: () => actions.updateAdditionalOption(opt),
                );
              }),
            ],
          ),

          const SizedBox(height: 28),

          // Translation Section
          _buildSectionHeader(
            theme: theme,
            title: 'Translation',
            subtitle: 'Display translated text below the original subtitles.',
          ),
          const SizedBox(height: 8),
          _buildOptionGroup(
            theme: theme,
            children: [
              _ReadingOptionTile(
                label: 'OFF',
                isSelected: !state.showTranslation,
                onTap: () => actions.updateShowTranslation(false),
              ),
              _ReadingOptionTile(
                label: 'ON',
                isSelected: state.showTranslation,
                onTap: () => actions.updateShowTranslation(true),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required AdditionalWindowTheme theme, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.titleColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: theme.subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionGroup({required AdditionalWindowTheme theme, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _ReadingOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReadingOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryAccent.withValues(alpha: 0.05) : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: theme.dividerColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? theme.primaryAccent : theme.normalText,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: theme.primaryAccent, size: 20)
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.dividerColor, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
