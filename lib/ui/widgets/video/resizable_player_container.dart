import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../styles/app_colors.dart';

class ResizablePlayerContainer extends StatefulWidget {
  final Widget child;
  const ResizablePlayerContainer({super.key, required this.child});

  @override
  State<ResizablePlayerContainer> createState() => _ResizablePlayerContainerState();
}

class _ResizablePlayerContainerState extends State<ResizablePlayerContainer> {
  double _height = 0;
  bool _isFirstLayout = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    if (_isFirstLayout) {
      // Default height is 16:9 of current width
      _height = screenWidth * 9 / 16;
      _isFirstLayout = false;
    }

    // Constraints change based on orientation
    final minHeight = orientation == Orientation.portrait ? screenWidth * 0.4 : screenHeight * 0.4;
    final maxHeight = orientation == Orientation.portrait ? screenHeight * 0.7 : screenHeight * 0.9;

    return Column(
      children: [
        Container(
          height: _height.clamp(minHeight, maxHeight),
          width: double.infinity,
          color: const Color(0xFF0F172A), // bg-dark
          child: widget.child,
        ),
        GestureDetector(
          onVerticalDragUpdate: (details) {
            setState(() {
              _height = (_height + details.delta.dy).clamp(minHeight, maxHeight);
            });
          },
          child: Container(
            height: 24,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              border: const Border(
                bottom: BorderSide(color: AppColors.slate200, width: 0.8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 12, child: Icon(Icons.expand_less, size: 15, color: AppColors.slate400)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.slate100,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: AppColors.slate200.withValues(alpha: 0.6)),
                  ),
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.slate400.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(width: 12, child: Icon(Icons.expand_more, size: 15, color: AppColors.slate400)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
