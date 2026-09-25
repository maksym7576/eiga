import 'package:flutter/material.dart';
import 'package:eiga/utils/ui/responsive_helper.dart';

/// A universal, reusable responsive container that ensures a clean layout 
/// across mobile, tablet, and desktop screens. It prevents content from 
/// stretching excessively on wide screens and adapts column layouts dynamically.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxContentWidth = 720.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// A reusable responsive grid builder that automatically updates the cross-axis count
/// based on the available screen width to look great on both phone and PC.
class ResponsiveGridBuilder extends StatelessWidget {
  final List<Widget> children;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final int mobileCrossAxisCount;
  final int tabletCrossAxisCount;
  final int desktopCrossAxisCount;

  const ResponsiveGridBuilder({
    super.key,
    required this.children,
    this.mainAxisSpacing = 12.0,
    this.crossAxisSpacing = 12.0,
    this.childAspectRatio = 1.6,
    this.mobileCrossAxisCount = 2,
    this.tabletCrossAxisCount = 3,
    this.desktopCrossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final displayType = ResponsiveHelper.getDisplayType(context);
    int crossAxisCount = mobileCrossAxisCount;

    if (displayType == DisplayType.tablet) {
      crossAxisCount = tabletCrossAxisCount;
    } else if (displayType == DisplayType.desktop) {
      crossAxisCount = desktopCrossAxisCount;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => children[index],
    );
  }
}
