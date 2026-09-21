import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/app_bar/app_blur_header.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/language_provider.dart';
import 'package:eiga/ui/widgets/shared/app_action_button.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/ui/widgets/player/app_player.dart';
import '../upload_sections.dart';

class UploadDesktopView extends StatefulWidget {
  final AdditionalWindowTheme theme;

  const UploadDesktopView({super.key, required this.theme});

  @override
  State<UploadDesktopView> createState() => _UploadDesktopViewState();
}

class _UploadDesktopViewState extends State<UploadDesktopView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(uploadProvider);
        final notifier = ref.read(uploadProvider.notifier);
        final languages = ref.watch(languageProvider);
        
        // Listen to the preview player's fullscreen state
        final isPlayerFullscreen = ref.watch(playerProvider('preview').select((s) => s.isFullscreen));

        // Фільтруємо список кроків відповідно до вибору джерела субтитрів
        final visibleSections = UploadScreenSection.values.where((s) => s.shouldInclude(state)).toList();
        
        // Коригуємо поточний індекс, якщо кількість кроків раптово зменшилась
        int currentIndex = state.currentStepIndex;
        if (currentIndex >= visibleSections.length) {
          currentIndex = visibleSections.isEmpty ? 0 : visibleSections.length - 1;
        }

        // Визначаємо поточний активний крок бізнес-процесу
        final activeSection = visibleSections.isNotEmpty ? visibleSections[currentIndex] : UploadScreenSection.videoSource;

        // Перевірка фінальної валідації для збереження відео
        final bool canAddVideo = state.videoPath != null && 
                                (state.fileName?.isNotEmpty ?? false) &&
                                (state.subtitleSource == SubtitleSource.ai || state.subtitlePath != null) && 
                                languages.original != null && 
                                languages.target != null &&
                                !state.isSaving;

        return Scaffold(
          backgroundColor: isPlayerFullscreen ? Colors.black : const Color(0xFFF8FAFC),
          appBar: isPlayerFullscreen 
            ? null 
            : AppBlurHeader(
                title: 'Create Video',
                onBack: () {
                  notifier.reset();
                  Navigator.pop(context);
                },
                actions: [
                  IconButton(
                    icon: const Icon(Icons.help_outline, size: 20, color: AppColors.slate600),
                    onPressed: () {},
                  ),
                ],
              ),
          body: isPlayerFullscreen
              ? AppPlayer(
                  scope: 'preview',
                  videoPath: state.videoPath,
                  phrases: state.previewPhrases,
                )
              : Column(
                  children: [
                    // Indicator
                    _buildStepIndicator(visibleSections, currentIndex, notifier),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: widget.theme.dividerColor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activeSection.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.slate900,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  activeSection.buildContent(state, isDesktop: true),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Nav
                    _buildBottomNav(visibleSections, state, notifier, canAddVideo, currentIndex),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildStepIndicator(List<UploadScreenSection> visibleSections, int currentIndex, UploadNotifier notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Row(
            children: List.generate(visibleSections.length, (index) {
              final section = visibleSections[index];
              final isCompleted = index < currentIndex;
              final isActive = index == currentIndex;
              
              return Expanded(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => notifier.setStepIndex(index),
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isActive 
                                  ? const Color(0xFF2563EB) 
                                  : (isCompleted ? const Color(0xFF10B981) : Colors.white),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isActive || isCompleted 
                                    ? Colors.transparent 
                                    : const Color(0xFFCBD5E1),
                                width: 2,
                              ),
                              boxShadow: isActive ? [
                                BoxShadow(
                                  color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ] : null,
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(Icons.check, size: 20, color: Colors.white)
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: isActive ? Colors.white : const Color(0xFF94A3B8),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            section.shortLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isActive || isCompleted ? FontWeight.w800 : FontWeight.w600,
                              color: isActive 
                                  ? const Color(0xFF2563EB) 
                                  : (isCompleted ? const Color(0xFF10B981) : const Color(0xFF94A3B8)),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < visibleSections.length - 1)
                      Expanded(
                        child: Container(
                          height: 3,
                          margin: const EdgeInsets.only(bottom: 24, left: 12, right: 12),
                          decoration: BoxDecoration(
                            color: isCompleted 
                                ? const Color(0xFF10B981) 
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(List<UploadScreenSection> visibleSections, UploadState state, UploadNotifier notifier, bool canAddVideo, int currentIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: widget.theme.dividerColor)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Row(
            children: [
              if (currentIndex > 0)
                SizedBox(
                  width: 150,
                  child: AppActionButton(
                    onPressed: () => notifier.setStepIndex(currentIndex - 1),
                    text: 'Previous',
                    type: AppActionButtonType.outlined,
                  ),
                )
              else
                SizedBox(
                  width: 150,
                  child: AppActionButton(
                    onPressed: () {
                      notifier.reset();
                      Navigator.pop(context);
                    },
                    text: 'Cancel',
                    type: AppActionButtonType.outlined,
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: currentIndex < visibleSections.length - 1
                    ? AppActionButton(
                        onPressed: () async {
                          if (currentIndex == 2 && state.subtitleSource == SubtitleSource.ai && state.activeSelection == null) {
                            final proceed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Proceed without subtitles?'),
                                content: const Text('AI transcription is still processing. For a better experience, we recommend waiting until it finishes. Do you want to proceed to the final step anyway?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Wait')),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Proceed')),
                                ],
                              ),
                            );
                            if (proceed != true) return;
                          }
                          notifier.setStepIndex(currentIndex + 1);
                        },
                        text: 'Next Step',
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      )
                    : AppActionButton(
                        onPressed: canAddVideo ? () => _onSave(context, notifier) : null,
                        text: 'Add Video',
                        isLoading: state.isSaving,
                        icon: const Icon(Icons.play_arrow_rounded),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSave(BuildContext context, UploadNotifier notifier) async {
    final success = await notifier.saveVideo();
    if (context.mounted) {
      if (success) {
        notifier.reset();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add video')));
      }
    }
  }
}
