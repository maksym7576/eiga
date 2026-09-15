import 'package:flutter/material.dart';

class ResizableSidebarContainer extends StatefulWidget {
  final Widget mainChild;
  final Widget sidebarChild;
  final double initialSidebarWidth;
  final double minSidebarWidth;
  final double maxSidebarWidth;

  const ResizableSidebarContainer({
    super.key,
    required this.mainChild,
    required this.sidebarChild,
    this.initialSidebarWidth = 450.0,
    this.minSidebarWidth = 300.0,
    this.maxSidebarWidth = 800.0,
  });

  @override
  State<ResizableSidebarContainer> createState() => _ResizableSidebarContainerState();
}

class _ResizableSidebarContainerState extends State<ResizableSidebarContainer> {
  late double _sidebarWidth;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _sidebarWidth = widget.initialSidebarWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Main Content (Video)
        Expanded(
          child: widget.mainChild,
        ),

        // Splitter / Draggable Handle
        MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: GestureDetector(
            onPanStart: (_) => setState(() => _isDragging = true),
            onPanEnd: (_) => setState(() => _isDragging = false),
            onPanUpdate: (details) {
              setState(() {
                _sidebarWidth -= details.delta.dx;
                _sidebarWidth = _sidebarWidth.clamp(
                  widget.minSidebarWidth,
                  widget.maxSidebarWidth,
                );
              });
            },
            child: Container(
              width: 8,
              color: _isDragging 
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5) 
                  : Colors.transparent,
              child: Center(
                child: Container(
                  width: 2,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Sidebar Content (Phrases)
        SizedBox(
          width: _sidebarWidth,
          child: widget.sidebarChild,
        ),
      ],
    );
  }
}
