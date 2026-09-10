import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../backend/database/schemas/translation_job.dart';
import '../../../../backend/services/background/translation_background_manager.dart';
import '../../../../providers/ui/hint_provider.dart';

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

class DetailedTranslationJobCard extends HookConsumerWidget {
  final TranslationJob job;
  final int index;
  final int total;
  final bool isCompact;

  const DetailedTranslationJobCard({
    super.key,
    required this.job,
    required this.index,
    required this.total,
    this.isCompact = false,
  });

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
          _Header(job: job, isActive: isActive, isError: isError, ref: ref),
          if (job.executionPlan != null) ...[
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
  final TranslationJob job;
  final bool isActive;
  final bool isError;
  final WidgetRef ref;

  const _Header({required this.job, required this.isActive, required this.isError, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              _Tag(text: (job.isAuto ?? true) ? 'Auto' : 'Manual'),
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
                    const TextSpan(text: '/ ', style: TextStyle(color: _C.grey, fontWeight: FontWeight.normal)),
                    TextSpan(text: '${job.totalPhrases ?? 0}'),
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
        if (isActive)
          _StopButton(onTap: () => ref.read(translationBackgroundManagerProvider).cancelTask(job.videoId))
        else
          _StatusBadge(isError: isError),
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

/// Сітка кроків (grid, рівна ширина колонок) — лінії позаду кружечків.
class _StepperGrid extends StatelessWidget {
  final TranslationJob job;
  final bool isCompact;
  const _StepperGrid({required this.job, required this.isCompact});

  static const _names = {
    'context': 'Context',
    'translation': 'Translate',
    'tokenize_source': 'Src Tok',
    'tokenize_translation': 'Trs Tok',
    'morphology': 'Morph',
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

class _StepColumn extends HookConsumerWidget {
  final String stepName;
  final String? stepType;
  final _StepState state;
  final Color leftColor;
  final Color rightColor;
  final bool isCompact;
  final TranslationJob job;
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
                  };
                  final fullName = fullNames[stepType] ?? stepName;
                  
                  ref.read(hintProvider.notifier).show(
                    fullName,
                    subMessage: 'Model: $_model',
                  );
                },
                child: _StepIcon(state: state, size: circleSize),
              ),
            ],
          ),
        ),
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
                  fontWeight: FontWeight.w700, // Slightly bolder for better readability at small size
                  color: state == _StepState.pending ? _C.grey : _C.dark,
                ),
              ),
              const SizedBox(height: 2),
              _StepFooter(state: state, durationMs: durationMs, startTime: startTime),
            ],
          ),
        ),
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
  const _StepIcon({required this.state, required this.size});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _StepState.done:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(color: _C.success, shape: BoxShape.circle),
          child: Icon(Icons.check, size: size * 0.55, color: Colors.white),
        );
      case _StepState.failed:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(color: _C.error, shape: BoxShape.circle),
          child: Icon(Icons.close, size: size * 0.5, color: Colors.white),
        );
      case _StepState.current:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: _C.accent, width: 2),
            boxShadow: [BoxShadow(color: _C.accent.withValues(alpha: 0.15), blurRadius: 6, spreadRadius: 1)],
          ),
          child: Center(
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: const BoxDecoration(color: _C.accent, shape: BoxShape.circle),
            ),
          ),
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
          child: Center(
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: const BoxDecoration(color: _C.greyLine, shape: BoxShape.circle),
            ),
          ),
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