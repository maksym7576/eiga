import 'package:flutter/material.dart';
import 'adaptive_selector_section.dart';
import 'app_selection_tile.dart';

/// A generic widget for building expandable selection sections.
/// Used for Video Source, Subtitle Source, Metadata Providers, etc.
class BaseExpandableSelector<T> extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final T selectedValue;
  final List<T> options;
  final String Function(T) getTitle;
  final String Function(T) getSubtitle;
  final IconData Function(T) getIcon;
  final void Function(bool) onExpandedChanged;
  final void Function(T) onSelected;

  const BaseExpandableSelector({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.selectedValue,
    required this.options,
    required this.getTitle,
    required this.getSubtitle,
    required this.getIcon,
    required this.onExpandedChanged,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveSelectorSection(
      title: title,
      isExpanded: isExpanded,
      collapsedChild: _buildTile(selectedValue, showToggle: true),
      children: options.map((option) => _buildTile(option)).toList(),
    );
  }

  Widget _buildTile(T value, {bool showToggle = false}) {
    final isSelected = selectedValue == value;

    return AppSelectionTile(
      title: getTitle(value),
      subtitle: getSubtitle(value),
      icon: getIcon(value),
      isSelected: isSelected,
      isExpanded: isExpanded,
      showToggle: showToggle,
      onTap: () {
        if (!isExpanded) {
          onExpandedChanged(true);
        } else {
          onSelected(value);
          onExpandedChanged(false);
        }
      },
    );
  }
}
