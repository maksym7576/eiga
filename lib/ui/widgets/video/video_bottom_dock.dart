import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../styles/app_colors.dart';
import '../shared/progress_ring.dart';
import '../dialogs/app_bottom_sheet.dart';
import 'translation_progress_sheet.dart';

class VideoBottomDock extends HookConsumerWidget {
  const VideoBottomDock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrasesAsync = ref.watch(phrasesStreamProvider);
    final isAutoScrollEnabled = ref.watch(isAutoScrollEnabledProvider);

    return phrasesAsync.when(
      data: (phrases) {
        if (phrases.isEmpty) return const SizedBox.shrink();

        final total = phrases.length;
        final translated = phrases.where((p) => p.isTranslated).length;
        final progress = total > 0 ? translated / total : 0.0;

        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                border: const Border(
                  top: BorderSide(color: Color(0xFFF1F5F9)),
                ),
              ),
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 8,
                bottom: MediaQuery.of(context).padding.bottom + 8,
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Progress Ring
                    GestureDetector(
                      onTap: () {
                        AppBottomSheet.show(
                          context: context,
                          child: const TranslationProgressSheet(),
                        );
                      },
                      child: ProgressRing(
                        progress: progress,
                        textStyle: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brandBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Primary Action Button (Right Now)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(isAutoScrollEnabledProvider.notifier).state = true;
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 44,
                          decoration: BoxDecoration(
                            color: isAutoScrollEnabled ? AppColors.brandBlue : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                            border: isAutoScrollEnabled
                                ? null
                                : Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: isAutoScrollEnabled
                                ? [
                                    BoxShadow(
                                      color: AppColors.brandBlue.withOpacity(0.25),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Pulsing indicator dot
                              _StatusDot(isActive: isAutoScrollEnabled),
                              const SizedBox(width: 8),
                              Text(
                                'Right now',
                                style: TextStyle(
                                  color: isAutoScrollEnabled ? Colors.white : AppColors.brandBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Settings Button
                    GestureDetector(
                      onTap: () {
                        // TODO: Open settings
                      },
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(
                          Icons.tune,
                          size: 19,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _StatusDot extends StatefulWidget {
  final bool isActive;
  const _StatusDot({required this.isActive});

  @override
  State<_StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<_StatusDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.brandBlue,
          shape: BoxShape.circle,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6 + (_controller.value * 0.4)),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.4 * _controller.value),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
