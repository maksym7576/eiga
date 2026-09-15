import 'package:flutter/material.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';

class AdaptiveSelectorSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final List<Widget> children;
  final Widget collapsedChild;

  const AdaptiveSelectorSection({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.children,
    required this.collapsedChild,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
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
                  children: _buildExpandedChildren(),
                )
              : KeyedSubtree(
                  key: const ValueKey('collapsed'),
                  child: collapsedChild,
                ),
        ),
      ],
    );
  }

  List<Widget> _buildExpandedChildren() {
    final List<Widget> results = [];
    for (int i = 0; i < children.length; i++) {
      results.add(children[i]);
      if (i < children.length - 1) {
        results.add(const SizedBox(height: 10));
      }
    }
    return results;
  }
}
