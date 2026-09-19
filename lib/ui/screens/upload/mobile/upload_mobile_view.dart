import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/app_bar/app_blur_header.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/language_provider.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:eiga/ui/widgets/shared/app_action_button.dart';
import 'package:eiga/ui/widgets/upload/selectors/video_source_selector.dart';
import 'package:eiga/ui/widgets/upload/sections/video_input_section.dart';

import '../../../widgets/upload/sections/episode_selection_section.dart';
import '../../../widgets/upload/sections/language_selection_section.dart';
import '../../../widgets/upload/sections/media_search_section.dart';
import '../../../widgets/upload/sections/phrases_preview_section.dart';
import '../../../widgets/upload/sections/subtitle_input_section.dart';
import '../../../widgets/upload/sections/subtitle_version_section.dart';

/// Статичний список усіх можливих кроків конфігурації.
enum UploadScreenSection {
  videoSource(title: 'Subtitles & Sync', shortLabel: 'Source'),
  mediaMatch(title: 'Subtitles & Sync', shortLabel: 'Match'),
  syncSubtitles(title: 'Subtitles & Sync', shortLabel: 'Subtitles'),
  languageTranslation(title: 'Subtitles & Sync', shortLabel: 'Finish');

  final String title;
  final String shortLabel;
  const UploadScreenSection({required this.title, required this.shortLabel});

  /// Динамічна логіка: якщо вибрано AI як джерело субтитрів, крок "Subtitles" взагалі викидається з таймлайну.
  bool shouldInclude(UploadState state) {
    if (this == UploadScreenSection.syncSubtitles) {
      return state.subtitleSource != SubtitleSource.ai;
    }
    return true;
  }

  Widget buildContent(UploadState state) {
    switch (this) {
      case UploadScreenSection.videoSource:
        return const Column(
          children: [
            VideoSourceSelector(),
            SizedBox(height: 16),
            VideoInputSection(),
          ],
        );
      case UploadScreenSection.mediaMatch:
        return const MediaSearchSection();
      case UploadScreenSection.syncSubtitles:
        return const Column(
          children: [
            EpisodeSelectionSection(),
            SubtitleVersionSection(),
            SizedBox(height: 10),
            SubtitleInputSection(),
            SizedBox(height: 16),
            PhrasesPreviewSection(),
          ],
        );
      case UploadScreenSection.languageTranslation:
        return const LanguageSelectionSection();
    }
  }
}

/// Скелет Екрана завантаження у вигляді горизонтального прогрес-бару кроків.
/// Кількість етапів динамічно зменшується до 3, якщо користувач вибрав AI субтитри.
class UploadMobileView extends StatefulWidget {
  final AdditionalWindowTheme theme;

  const UploadMobileView({super.key, required this.theme});

  @override
  State<UploadMobileView> createState() => _UploadMobileViewState();
}

class _UploadMobileViewState extends State<UploadMobileView> {
  int _currentStepIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(uploadProvider);
        final notifier = ref.read(uploadProvider.notifier);
        final languages = ref.watch(languageProvider);

        // Фільтруємо список кроків відповідно до вибору джерела субтитрів (AI зменшує кількість етапів)
        final visibleSections = UploadScreenSection.values.where((s) => s.shouldInclude(state)).toList();
        
        // Коригуємо поточний індекс, якщо кількість кроків раптово зменшилась
        if (_currentStepIndex >= visibleSections.length) {
          _currentStepIndex = visibleSections.isEmpty ? 0 : visibleSections.length - 1;
        }

        // Визначаємо поточний активний крок бізнес-процесу
        final activeSection = visibleSections.isNotEmpty ? visibleSections[_currentStepIndex] : UploadScreenSection.videoSource;

        // Перевірка фінальної валідації для збереження відео
        final bool canAddVideo = state.videoPath != null && 
                                (state.subtitleSource == SubtitleSource.ai || state.subtitlePath != null) && 
                                languages.original != null && 
                                languages.target != null &&
                                !state.isSaving;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBlurHeader(
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
          body: Column(
            children: [
              // 1. Верхній індикатор кроків (Step Indicator) - ДИНАМІЧНИЙ (3 або 4 кроки)
              if (visibleSections.isNotEmpty) ...[
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    children: [
                      // Текст: Step X of Y: Назва кроку
                      Text(
                        'Step ${_currentStepIndex + 1} of ${visibleSections.length}: ${activeSection.shortLabel}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Горизонтальні лінії кроків (Линейки прогресса)
                      Row(
                        children: List.generate(visibleSections.length, (index) {
                          final isCompleted = index < _currentStepIndex;
                          final isActive = index == _currentStepIndex;
                          
                          Color barColor = const Color(0xFFE2E8F0); // Неактивний сірий
                          if (isCompleted) barColor = const Color(0xFF10B981); // Завершений зелений
                          if (isActive) barColor = widget.theme.primaryAccent; // Поточний синій

                          return Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: EdgeInsets.only(
                                right: index == visibleSections.length - 1 ? 0 : 8,
                              ),
                              height: 5,
                              decoration: BoxDecoration(
                                color: barColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      // Текстові підписи під лініями (Source, Match, Subtitles, Finish)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(visibleSections.length, (index) {
                          final section = visibleSections[index];
                          final isCompleted = index < _currentStepIndex;
                          final isActive = index == _currentStepIndex;

                          Color textColor = const Color(0xFF94A3B8); // Дефолтний сірий текст
                          if (isCompleted) textColor = const Color(0xFF10B981);
                          if (isActive) textColor = widget.theme.primaryAccent;

                          return Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isCompleted) ...[
                                  const Icon(Icons.check, size: 11, color: Color(0xFF10B981)),
                                  const SizedBox(width: 2),
                                ] else if (isActive) ...[
                                  Icon(Icons.circle, size: 6, color: widget.theme.primaryAccent),
                                  const SizedBox(width: 4),
                                ],
                                Flexible(
                                  child: Text(
                                    section.shortLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: (isActive || isCompleted) ? FontWeight.bold : FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: const Color(0xFFF1F5F9)),
              ],

              // 2. Основна область вмісту поточного кроку
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: activeSection.buildContent(state),
                ),
              ),

              // 3. Нижні навігаційні кнопки: PREVIOUS та NEXT / FINISH
              Container(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: widget.theme.dividerColor)),
                ),
                child: Row(
                  children: [
                    // Кнопка PREVIOUS (Назад)
                    Expanded(
                      child: _currentStepIndex > 0
                          ? AppActionButton(
                              onPressed: () {
                                setState(() {
                                  _currentStepIndex--;
                                });
                              },
                              text: 'Previous',
                              type: AppActionButtonType.outlined,
                            )
                          : AppActionButton(
                              onPressed: () {
                                notifier.reset();
                                Navigator.pop(context);
                              },
                              text: 'Cancel',
                              type: AppActionButtonType.outlined,
                            ),
                    ),
                    const SizedBox(width: 12),
                    // Кнопка NEXT або ADD VIDEO
                    Expanded(
                      flex: 2,
                      child: _currentStepIndex < visibleSections.length - 1
                          ? AppActionButton(
                              onPressed: () {
                                setState(() {
                                  _currentStepIndex++;
                                });
                              },
                              text: 'Next Step',
                              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
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
            ],
          ),
        );
      },
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
