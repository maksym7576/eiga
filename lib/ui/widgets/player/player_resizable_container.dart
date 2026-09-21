import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../styles/app_colors.dart';
import 'package:eiga/providers/ui/player_provider.dart';

class PlayerResizableContainer extends ConsumerWidget {
  final Widget child;
  final String playerScope;
  const PlayerResizableContainer({super.key, required this.child, this.playerScope = 'main'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    
    final playerState = ref.watch(playerProvider(playerScope));
    final resizableHeight = playerState.resizableHeight;

    // Constraints change based on orientation
    final minHeight = orientation == Orientation.portrait ? screenWidth * 0.4 : screenHeight * 0.4;
    final maxHeight = orientation == Orientation.portrait ? screenHeight * 0.7 : screenHeight * 0.9;

    // Initial height calculation if not set
    final double currentHeight = resizableHeight ?? (screenWidth * 9 / 16);

    return Column(
      children: [
        Container(
          height: currentHeight.clamp(minHeight, maxHeight),
          width: double.infinity,
          color: const Color(0xFF0F172A), // bg-dark
          child: child,
        ),
        GestureDetector(
          onVerticalDragUpdate: (details) {
            final newHeight = (currentHeight + details.delta.dy).clamp(minHeight, maxHeight);
            ref.read(playerProvider(playerScope).notifier).updateResizableHeight(newHeight);
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
