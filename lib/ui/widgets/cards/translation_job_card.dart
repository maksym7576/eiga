import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../backend/database/schemas/job.dart';
import '../../../../backend/services/background/translation_background_manager.dart';
import 'package:eiga/providers/ui/hint_provider.dart';
import 'package:eiga/ui/widgets/shared/video_timeline_progress.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:eiga/providers/services/ai_request_state.dart';

/// Кольорова палітра, як у макеті (iOS-style)
class _C {
  static const accent = Color(0xFF0A84FF);
  static const accentBg = Color(0xFFEFF6FF);
  static const accentBorder = Color(0xFFDBEAFE);
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const errorDark = Color(0xFFE11D48);
  static const errorBg = Color(0xFFFFF1F2);
  static const errorBorder = Color(0xFFFECDD3);
  static const errorBorderSoft = Color(0xFFFDA4AF);
  static const errorLine = Color(0xFFFECACA);
  static const grey = Color(0xFF94A3B8);
  static const greyLine = Color(0xFFE2E8F0);
  static const dark = Color(0xFF1E293B);
  static const cardBorder = Color(0xFFE9ECEF);
}

enum _StepState { done, current, failed, pending }

class TranslationJobCard extends HookConsumerWidget {
  final Job job;
  final int index;
  final int total;
  final bool isCompact;
  final bool hasHistory;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;

  const TranslationJobCard({
    super.key,
    required this.job,
    required this.index,
    required this.total,
    this.isCompact = false,
    this.hasHistory = false,
    this.isExpanded = false,
    this.onToggleExpand,
  });

  String _formatPhraseOrders(List<int>? orders) {
    if (orders == null || orders.isEmpty) return 'No phrases';
    if (orders.length == 1) return 'Phrase #${orders.first}';
    
    final sorted = List<int>.from(orders)..sort();
    final List<String> parts = [];
    
    int start = sorted[0];
    int prev = sorted[0];
    
    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i] == prev + 1) {
        prev = sorted[i];
      } else {
        parts.add(start == prev ? '#$start' : '#$start-$prev');
        start = sorted[i];
        prev = sorted[i];
      }
    }
    parts.add(start == prev ? '#$start' : '#$start-$prev');
    
    final result = parts.join(', ');
    if (result.length > 30) {
      return '${orders.length} phrases (${parts.first}...)';
    }
    return 'Phrases $result';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = job.status ?? 'active';
    final isActive = status == 'active';
    final isError = status == 'error';

    return Container(
      margin: EdgeInsets.only(bottom: isCompact ? 10 : 14),
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(
            job: job, 
            isActive: isActive, 
            isError: isError, 
            ref: ref, 
            formattedOrders: _formatPhraseOrders(job.phraseOrders),
            hasHistory: hasHistory,
            isExpanded: isExpanded,
            onToggleExpand: onToggleExpand,
          ),
          if (job.pipelineId == 'ai_transcription_v1' && job.phase != null) ...[
            const SizedBox(height: 12),
            Text(
              job.phase!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? _C.accent : _C.dark,
              ),
            ),
            const SizedBox(height: 8),
            _TranscriptionTimeBreakdown(job: job),
          ],
          if (job.executionPlan != null && job.pipelineId != 'ai_transcription_v1') ...[
            const SizedBox(height: 20),
            _StepperGrid(job: job, isCompact: isCompact),
          ],
          if (isError && job.errorMessage != null) ...[
            const SizedBox(height: 14),
            _ErrorBanner(message: job.errorMessage!),
          ],
        ],
      ),
    );
  }
}

/// Верхній рядок: тег, модель, лічильник, іконка статусу / кнопка стоп
class _Header extends StatelessWidget {
  final Job job;
  final bool isActive;
  final bool isError;
  final WidgetRef ref;
  final String formattedOrders;
  final bool hasHistory;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;

  const _Header({
    required this.job,
    required this.isActive,
    required this.isError,
    required this.ref,
    required this.formattedOrders,
    this.hasHistory = false,
    this.isExpanded = false,
    this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  _Tag(text: job.pipelineId == 'ai_transcription_v1' ? 'AI Transcribe' : ((job.isAuto ?? true) ? 'Auto' : 'Manual')),
                  const SizedBox(width: 8),
                  if (job.modelName != null)
                    Flexible(
                      child: Text(
                        job.modelName!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _C.dark,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${job.processedPhrases ?? 0} '),
                        if (job.pipelineId != 'ai_transcription_v1') ...[
                          const TextSpan(text: '/ ', style: TextStyle(color: _C.grey, fontWeight: FontWeight.normal)),
                          TextSpan(text: '${job.totalPhrases ?? 0}'),
                        ] else ...[
                          const TextSpan(text: '% ', style: TextStyle(color: _C.grey, fontWeight: FontWeight.normal)),
                          TextSpan(
                            text: '(${job.totalPhrases ?? 0})',
                            style: const TextStyle(fontSize: 10, color: _C.grey),
                          ),
                        ],
                      ],
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                      color: _C.dark,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                if (isActive)
                  _StopButton(onTap: () => ref.read(translationBackgroundManagerProvider).cancelTask(job.videoId))
                else
                  _StatusBadge(isError: isError),
                if (hasHistory) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onToggleExpand,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isExpanded ? _C.accentBg : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: isExpanded ? _C.accentBorder : _C.greyLine.withValues(alpha: 0.5)),
                      ),
                      child: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 18,
                        color: isExpanded ? _C.accent : _C.grey,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          formattedOrders,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _C.grey,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        _ElapsedTimeWidget(job: job),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isError;
  const _StatusBadge({required this.isError});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isError ? _C.errorBg : const Color(0xFFECFDF5),
        shape: BoxShape.circle,
        border: Border.all(color: isError ? _C.errorBorderSoft : _C.success.withValues(alpha: 0.2)),
      ),
      child: Icon(
        isError ? Icons.priority_high_rounded : Icons.check,
        size: 14,
        color: isError ? _C.errorDark : _C.success,
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _C.accentBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.accentBorder),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _C.accent),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _C.errorBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.errorBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: _C.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9F1239)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptionTimeBreakdown extends ConsumerWidget {
  final Job job;
  const _TranscriptionTimeBreakdown({required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(videoProvider(job.videoId));
    final phrasesAsync = ref.watch(phrasesByVideoIdProvider(job.videoId));

    final video = videoAsync.value;
    final phrases = phrasesAsync.value ?? [];

    if (video == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AiActivityLogSection(job: job),
          const SizedBox(height: 12),
          _VideoInternalDataSection(job: job),
        ],
      ),
    );
  }
}

class _VideoInternalDataSection extends ConsumerWidget {
  final Job job;
  const _VideoInternalDataSection({required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(videoProvider(job.videoId));
    final video = videoAsync.value;

    if (video == null) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.slate50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate200),
          ),
          child: ExpansionTile(
            title: const Row(
              children: [
                Icon(Icons.code_rounded, size: 14, color: AppColors.brandBlue),
                SizedBox(width: 6),
                Text(
                  'Video Internal Data & AI Schema',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.slate700),
                ),
              ],
            ),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            children: [
              _kvRow('File Name', video.fileName ?? 'N/A'),
              _kvRow('Metadata Source', video.metadataProvider ?? 'N/A'),
              _kvRow('Subtitle Source', video.subtitleSource ?? 'N/A'),
              _kvRow('Subtitle Method', video.subtitleMethodUsed ?? 'N/A'),
              _kvRow('Languages', '${video.originalLanguage ?? 'Unknown'} - ${video.translatedLanguage ?? 'Unknown'}'),
              _kvRow('Season / Episode', 'S${video.season ?? '1'} . Ep ${video.episode ?? '1'}'),
              _kvRow('Audio Stream Index', '${video.selectedAudioTrackIndex ?? 0}'),
              _kvRow('Is Subtitle Ready', video.isSubtitleReady == true ? 'YES' : 'NO'),
              _kvRow('Total Blocks', '${video.transcriptionBlocks?.length ?? 0} blocks'),
              _kvRow('Created At', video.createdAt?.toString() ?? 'N/A'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kvRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: const TextStyle(fontSize: 10, color: AppColors.slate500, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 10, color: AppColors.slate800, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}

class _AiActivityLogSection extends ConsumerWidget {
  final Job job;
  const _AiActivityLogSection({required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(videoProvider(job.videoId));
    final video = videoAsync.value;
    final blocks = video?.transcriptionBlocks ?? [];
    final completedCount = blocks.where((b) => b.status == 'completed' || b.status == 'warning').length;
    final totalCount = blocks.isNotEmpty ? blocks.length : 1;
    final bool isAllCompleted = blocks.isNotEmpty && completedCount == blocks.length;

    final logs = video?.activityLogs ?? [];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.verified_rounded, size: 14, color: AppColors.brandBlue),
                  SizedBox(width: 6),
                  Text(
                    'Local AI Quality Judge & Model History',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.slate700),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isAllCompleted ? 'Completed' : 'Processing ($completedCount/$totalCount)',
                  style: TextStyle(
                    fontSize: 9, 
                    fontWeight: FontWeight.bold, 
                    color: isAllCompleted ? const Color(0xFF10B981) : AppColors.brandBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (logs.isEmpty)
            const Text(
              'Initializing transcription worker threads...',
              style: TextStyle(fontSize: 10, color: AppColors.slate500, fontStyle: FontStyle.italic),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: ListView.builder(
                shrinkWrap: false,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final ev = logs[logs.length - 1 - index];
                  final isAnalyzer = (ev.modelName ?? '').contains('AudioAnalyzer');
                  final isSuccess = ev.result == 'success';
                  final color = isAnalyzer ? AppColors.brandBlue : (isSuccess ? const Color(0xFF10B981) : AppColors.warningText);
                  final timeStr = ev.timestamp != null 
                      ? '${ev.timestamp!.hour.toString().padLeft(2, '0')}:${ev.timestamp!.minute.toString().padLeft(2, '0')}:${ev.timestamp!.second.toString().padLeft(2, '0')}'
                      : '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 6, 
                          height: 6, 
                          decoration: BoxDecoration(
                            color: color, 
                            shape: isAnalyzer ? BoxShape.rectangle : BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '[$timeStr]',
                          style: const TextStyle(fontSize: 9, color: AppColors.slate400, fontFamily: 'monospace'),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          ev.modelName ?? 'AI',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.slate800),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            ev.message ?? (isSuccess ? 'Success' : 'Error'),
                            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          if (isAllCompleted) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xA010B981)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '✅ All audio chunks successfully transcribed, evaluated by local judge, and verified!',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF065F46)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Сітка кроків (grid, рівна ширина колонок) — лінії позаду кружечків.
class _StepperGrid extends StatelessWidget {
  final Job job;
  final bool isCompact;
  const _StepperGrid({required this.job, required this.isCompact});

  static const _names = {
    'context': 'Context',
    'translation': 'Translate',
    'tokenize_source': 'Src Tok',
    'tokenize_translation': 'Trs Tok',
    'morphology': 'Morph',
    'grammar_role': 'Grammar',
  };

  String _stepName(Map<String, dynamic> step) {
    final type = step['type'] as String?;
    final method = (step['method'] as String?)?.toLowerCase();
    final base = _names[type] ?? type ?? 'Unknown';
    
    final methodSuffix = method == 'ai' ? ' (AI)' : (method == 'local' ? ' (LOC)' : '');
    return '$base$methodSuffix';
  }

  _StepState _stateFor(int i, int completed, bool isActive, bool isError, bool isSuccess) {
    if (i < completed || isSuccess) return _StepState.done;
    if (i == completed && isError) return _StepState.failed;
    if (i == completed && isActive) return _StepState.current;
    return _StepState.pending;
  }

  @override
  Widget build(BuildContext context) {
    if (job.executionPlan == null) return const SizedBox.shrink();

    final plan = (jsonDecode(job.executionPlan!) as List).cast<Map<String, dynamic>>();
    final completed = job.completedSteps ?? 0;
    final status = job.status ?? 'active';
    final isActive = status == 'active';
    final isError = status == 'error';
    final isSuccess = status == 'success';

    final states = [
      for (var i = 0; i < plan.length; i++) _stateFor(i, completed, isActive, isError, isSuccess),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < plan.length; i++)
          Expanded(
            child: _StepColumn(
              stepName: _stepName(plan[i]),
              stepType: plan[i]['type'] as String?,
              state: states[i],
              leftColor: i == 0 ? Colors.transparent : _lineColor(states[i - 1], states[i]),
              rightColor: i == plan.length - 1 ? Colors.transparent : _lineColor(states[i], states[i + 1]),
              isCompact: isCompact,
              job: job,
              index: i,
            ),
          ),
      ],
    );
  }

  /// Колір лінії між двома сусідніми кроками
  Color _lineColor(_StepState a, _StepState b) {
    if (a == _StepState.done && (b == _StepState.done || b == _StepState.current)) return _C.success;
    if (a == _StepState.failed) return _C.errorLine;
    return _C.greyLine;
  }
}

IconData _stepIconFor(String? stepType) {
  switch (stepType) {
    case 'context': return Icons.lightbulb_outline;
    case 'translation': return Icons.translate;
    case 'tokenize_source': return Icons.subject;
    case 'tokenize_translation': return Icons.short_text;
    case 'morphology': return Icons.grain;
    case 'grammar_role': return Icons.schema;
    default: return Icons.radio_button_unchecked;
  }
}

class _StepColumn extends HookConsumerWidget {
  final String stepName;
  final String? stepType;
  final _StepState state;
  final Color leftColor;
  final Color rightColor;
  final bool isCompact;
  final Job job;
  final int index;

  const _StepColumn({
    required this.stepName,
    this.stepType,
    required this.state,
    required this.leftColor,
    required this.rightColor,
    required this.isCompact,
    required this.job,
    required this.index,
  });

  String get _model {
    final hist = job.stageHistory;
    switch (state) {
      case _StepState.done:
      case _StepState.failed:
        if (hist != null && index < hist.length) return hist[index].modelName ?? 'Unknown';
        return job.modelName ?? 'Unknown';
      case _StepState.current:
        return job.modelName ?? 'AI Model';
      case _StepState.pending:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hist = job.stageHistory;
    final durationMs =
    (state == _StepState.done || state == _StepState.failed) && hist != null && index < hist.length
        ? hist[index].durationMs
        : null;
    final startTime = state == _StepState.current
        ? job.startTime?.add(Duration(
      milliseconds: hist?.fold<int>(0, (sum, e) => sum + (e.durationMs ?? 0)) ?? 0,
    ))
        : null;

    final circleSize = isCompact ? 24.0 : 28.0;
    final bool isMobile = MediaQuery.sizeOf(context).width < 600 || isCompact;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: circleSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  Expanded(child: Container(height: 2, color: leftColor)),
                  SizedBox(width: circleSize),
                  Expanded(child: Container(height: 2, color: rightColor)),
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  final fullNames = {
                    'context': 'Context Research',
                    'translation': 'Translation',
                    'tokenize_source': 'Source Tokenization',
                    'tokenize_translation': 'Translation Tokenization',
                    'morphology': 'Morphology Analysis',
                    'grammar_role': 'Grammar Roles & Diagram',
                  };
                  final fullName = fullNames[stepType] ?? stepName;
                  
                  ref.read(hintProvider.notifier).show(
                    fullName,
                    subMessage: 'Model: $_model',
                  );
                },
                child: Tooltip(
                  message: '$stepName ($_model)',
                  child: _StepIcon(state: state, size: circleSize, stepType: stepType),
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stepName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isCompact ? 10 : 11,
                    fontWeight: FontWeight.w700,
                    color: state == _StepState.pending ? _C.grey : _C.dark,
                  ),
                ),
                const SizedBox(height: 2),
                _StepFooter(state: state, durationMs: durationMs, startTime: startTime),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StepFooter extends HookWidget {
  final _StepState state;
  final int? durationMs;
  final DateTime? startTime;

  const _StepFooter({required this.state, this.durationMs, this.startTime});

  @override
  Widget build(BuildContext context) {
    if (state == _StepState.failed) {
      return const Text(
        'Failed',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _C.errorDark, letterSpacing: 0.3),
      );
    }
    if (durationMs != null) {
      return Text(
        '${(durationMs! / 1000).toStringAsFixed(1)}s',
        style: const TextStyle(fontSize: 11, color: _C.success, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
      );
    }
    if (state == _StepState.current && startTime != null) {
      useStream(useMemoized(() => Stream.periodic(const Duration(milliseconds: 100)), [startTime]));
      final elapsed = DateTime.now().difference(startTime!).inMilliseconds / 1000;
      return Text(
        '${elapsed.toStringAsFixed(1)}s',
        style: const TextStyle(fontSize: 11, color: _C.accent, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
      );
    }
    return const SizedBox.shrink();
  }
}

class _StepIcon extends StatelessWidget {
  final _StepState state;
  final double size;
  final String? stepType;
  const _StepIcon({required this.state, required this.size, this.stepType});

  @override
  Widget build(BuildContext context) {
    final iconData = _stepIconFor(stepType);

    switch (state) {
      case _StepState.done:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(color: _C.success, shape: BoxShape.circle),
          child: Icon(iconData, size: size * 0.52, color: Colors.white),
        );
      case _StepState.failed:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(color: _C.error, shape: BoxShape.circle),
          child: Icon(iconData, size: size * 0.52, color: Colors.white),
        );
      case _StepState.current:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: _C.accentBg,
            shape: BoxShape.circle,
            border: Border.all(color: _C.accent, width: 2),
            boxShadow: [BoxShadow(color: _C.accent.withValues(alpha: 0.15), blurRadius: 6, spreadRadius: 1)],
          ),
          child: Icon(iconData, size: size * 0.52, color: _C.accent),
        );
      case _StepState.pending:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: _C.greyLine, width: 2),
          ),
          child: Icon(iconData, size: size * 0.52, color: _C.grey),
        );
    }
  }
}

class _StopButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StopButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancel translation?'),
          content: const Text('Are you sure you want to stop the translation for this batch?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
            TextButton(
              onPressed: () {
                onTap();
                Navigator.pop(context);
              },
              child: const Text('Yes, stop', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), shape: BoxShape.circle),
        child: const Icon(Icons.close, size: 14, color: _C.grey),
      ),
    );
  }
}

class _ElapsedTimeWidget extends HookWidget {
  final Job job;
  const _ElapsedTimeWidget({required this.job});

  @override
  Widget build(BuildContext context) {
    if (job.startTime == null) return const SizedBox.shrink();

    final isActive = job.status == 'active';
    if (isActive) {
      useStream(useMemoized(() => Stream.periodic(const Duration(milliseconds: 100)), [job.startTime]));
    }

    final end = job.endTime ?? DateTime.now();
    final elapsedSec = end.difference(job.startTime!).inMilliseconds / 1000;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer_outlined, size: 12, color: _C.grey),
        const SizedBox(width: 4),
        Text(
          isActive ? 'Elapsed: ${elapsedStr(elapsedSec)}' : 'Duration: ${elapsedStr(elapsedSec)}',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: _C.grey,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  String elapsedStr(double sec) {
    if (sec < 60) return '${sec.toStringAsFixed(1)}s';
    int m = (sec ~/ 60);
    int s = (sec % 60).toInt();
    return '${m}m ${s}s';
  }
}
