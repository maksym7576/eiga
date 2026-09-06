import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../backend/database/schemas/translation_job.dart';
import '../../../../backend/database/schemas/video.dart';
import '../../../../backend/services/background/translation_background_manager.dart';
import '../../../styles/app_colors.dart';

class TranslationJobCard extends ConsumerWidget {
  final TranslationJob job;
  final int index;
  final int total;
  
  const TranslationJobCard({
    super.key, 
    required this.job,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = job.status ?? 'active';
    final isActive = status == 'active';
    final isError = status == 'error';
    final isSuccess = status == 'success';

    final isAnalytical = job.pipelineId == 'context_translation_v1';
    
    // Theme colors based on status
    Color accentColor;
    Color tagBg;
    Color tagText;
    
    if (isError) {
      accentColor = const Color(0xFFEF4444);
      tagBg = const Color(0xFFFEF2F2);
      tagText = const Color(0xFFEF4444);
    } else if (isSuccess) {
      accentColor = const Color(0xFF10B981);
      tagBg = const Color(0xFFECFDF5);
      tagText = const Color(0xFF059669);
    } else {
      // Active
      accentColor = isAnalytical ? const Color(0xFF6366F1) : const Color(0xFF3B82F6);
      tagBg = isAnalytical ? const Color(0xFFEEF2FF) : const Color(0xFFEFF6FF);
      tagText = isAnalytical ? const Color(0xFF4338CA) : const Color(0xFF1D4ED8);
    }

    final totalDuration = (job.stageHistory?.fold(0, (sum, e) => sum + (e.durationMs ?? 0)) ?? 0) / 1000;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(width: 4, decoration: BoxDecoration(color: accentColor, borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)))),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _Tag(label: isAnalytical ? 'Analytical' : 'Direct', bgColor: tagBg, textColor: tagText),
                        const SizedBox(width: 8),
                        Text(
                          job.modelName ?? 'AI Model',
                          style: TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.bold, 
                            color: isActive ? AppColors.slate700 : AppColors.slate600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (total > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '$index / $total',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: AppColors.slate700),
                            ),
                          ),
                        const SizedBox(width: 6),
                        if (isActive)
                          _StopButton(onTap: () {
                            ref.read(translationBackgroundManagerProvider).cancelTask(job.videoId);
                          })
                        else
                          Icon(isError ? Icons.error_outline : Icons.check_circle, size: 18, color: accentColor),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (isActive)
                      _PulsingDot(color: accentColor, size: 6)
                    else
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      'Phrases 1–${job.totalPhrases}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.slate900),
                    ),
                    const Spacer(),
                    if (isActive)
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                          children: [
                            TextSpan(text: '${job.processedPhrases ?? 0}', style: TextStyle(color: accentColor)),
                            const TextSpan(text: ' / ', style: TextStyle(color: AppColors.slate400)),
                            TextSpan(text: '${job.totalPhrases ?? 0}', style: const TextStyle(color: AppColors.slate400)),
                          ],
                        ),
                      )
                    else
                      Text(
                        '${job.processedPhrases} / ${job.totalPhrases} (100%)',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accentColor, fontFamily: 'monospace'),
                      ),
                  ],
                ),
                if (isError && job.errorMessage != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Error at stage: ${job.errorStage ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 10, color: Color(0xFFEF4444), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    job.errorMessage!,
                    style: const TextStyle(fontSize: 11, color: Color(0xFFB91C1C), fontStyle: FontStyle.italic),
                  ),
                ],

                if (isAnalytical) ...[
                  const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: AppColors.slate100)),
                  _PipelineStepper(job: job, accentColor: accentColor),
                ],

                if (!isActive) ...[
                  if (!isAnalytical) const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: AppColors.slate100)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${isAnalytical ? '3-stage' : '1-stage'} processing • 100% accuracy',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.slate500),
                      ),
                      Text(
                        'Time: ${totalDuration.toStringAsFixed(1)}s',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.slate600),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PipelineStepper extends StatelessWidget {
  final TranslationJob job;
  final Color accentColor;
  const _PipelineStepper({required this.job, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final stages = ['Context', 'Translation', 'Morphology'];
    final internalNames = ['Context', 'Translation', 'Morphology'];
    final isActive = job.status == 'active';
    
    return Row(
      children: List.generate(stages.length, (index) {
        final stageName = internalNames[index];
        final displayLabel = stages[index];
        
        final history = (job.stageHistory ?? []).cast<AiStageHistory?>().firstWhere(
          (h) => h?.stageName == stageName, 
          orElse: () => null,
        );
        
        final isCompleted = history?.status == 'success';
        final isCurrent = job.phase == stageName && !isCompleted;
        final isFailed = job.errorStage == stageName;
        final duration = history?.durationMs != null ? '${(history!.durationMs! / 1000).toStringAsFixed(1)}s' : '0.0s';

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: isCompleted ? const Color(0xFF10B981) : (isCurrent ? accentColor : (isFailed ? const Color(0xFFEF4444) : AppColors.slate100)),
                      shape: BoxShape.circle,
                      boxShadow: (isCurrent && isActive) ? [BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 4, spreadRadius: 1)] : null,
                    ),
                    child: Center(
                      child: isCompleted 
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : (isFailed
                            ? const Icon(Icons.close, size: 12, color: Colors.white)
                            : (isCurrent && isActive
                                ? const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.slate300, shape: BoxShape.circle)))),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(displayLabel, style: TextStyle(fontSize: 9, fontWeight: (isCurrent && isActive) ? FontWeight.bold : FontWeight.w600, color: (isCurrent && isActive) ? const Color(0xFF1E1B4B) : AppColors.slate500)),
                  Text(duration, style: const TextStyle(fontSize: 8, fontFamily: 'monospace', color: AppColors.slate400)),
                  if (history?.modelName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        history!.modelName!,
                        style: const TextStyle(fontSize: 7, color: AppColors.slate300, overflow: TextOverflow.ellipsis),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                ],
              ),
              if (index < stages.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 24, left: 4, right: 4),
                    decoration: BoxDecoration(
                      color: isCompleted ? const Color(0xFF10B981) : AppColors.slate300.withValues(alpha: 0.3),
                      gradient: (isCompleted && index < stages.length - 1) 
                        ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF10B981)]) // Simplified for history
                        : null,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  const _Tag({required this.label, required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4), border: Border.all(color: textColor.withValues(alpha: 0.2))),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: textColor)),
    );
  }
}

class _StopButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StopButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22, height: 22,
        decoration: BoxDecoration(color: AppColors.slate100, shape: BoxShape.circle, border: Border.all(color: AppColors.slate200)),
        child: const Icon(Icons.close, size: 12, color: AppColors.slate400),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  final double size;
  const _PulsingDot({required this.color, required this.size});
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size, height: widget.size,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.4 + (_controller.value * 0.6)),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: widget.color.withValues(alpha: 0.2 * _controller.value), blurRadius: 4, spreadRadius: 1),
            ],
          ),
        );
      },
    );
  }
}
