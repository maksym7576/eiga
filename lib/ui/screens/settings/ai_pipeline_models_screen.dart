import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/config/pipelines/pipeline_steps.dart';
import 'package:eiga/providers/ui/ai_models_state_provider.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/app_bar/app_blur_header.dart';
import 'package:eiga/ui/widgets/responsive/responsive_container.dart';
import 'model_selection_screen.dart';
import 'processing_mode_screen.dart';
import 'audio_processing_mode_screen.dart';

class AiPipelineModelsScreen extends ConsumerStatefulWidget {
  const AiPipelineModelsScreen({super.key});

  @override
  ConsumerState<AiPipelineModelsScreen> createState() => _AiPipelineModelsScreenState();
}

class _AiPipelineModelsScreenState extends ConsumerState<AiPipelineModelsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final aiState = ref.watch(aiModelsProvider);
    final allModelsAsync = ref.watch(allModelsProvider);
    final config = ref.watch(appConfigsServiceProvider);

    final isAutoSwitch = config.getIsAutomaticModelSwitch;

    // Separate text processing stages (5 stages) and audio processing stages (1 stage)
    final textStages = [
      TranslationPipelineStep.research,
      TranslationPipelineStep.translate,
      TranslationPipelineStep.tokenize,
      TranslationPipelineStep.morphemes,
      TranslationPipelineStep.grammarRole,
    ];

    final audioStages = [
      TranslationPipelineStep.transcribe,
    ];

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: const AppBlurHeader(
        title: 'AI Pipeline & Models',
      ),
      body: SingleChildScrollView(
        child: ResponsiveContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Feature Toggle: Automatic Model Switching Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.primaryAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.swap_calls_rounded, color: theme.primaryAccent, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Automatic Model Switching',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.titleColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Switch to fallback models if the current one fails.',
                            style: TextStyle(fontSize: 12, color: theme.mutedText),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: isAutoSwitch,
                      activeColor: theme.primaryAccent,
                      onChanged: (value) async {
                        await config.setIsAutomaticModelSwitch(value);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Pillar 1: Text Processing Mode Section
              _buildSectionHeader(context, 'Processing Mode (5 Stages)'),
              const SizedBox(height: 12),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProcessingModeScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B66F5), Color(0xFF5A82FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '5-Stage Advanced Pipeline',
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Maximum quality and depth of analysis. Tap to see how it works.',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withValues(alpha: 0.7), size: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ResponsiveGridBuilder(
                mobileCrossAxisCount: 2,
                tabletCrossAxisCount: 3,
                desktopCrossAxisCount: 3,
                childAspectRatio: 1.5,
                children: textStages.map((step) {
                  final activeModel = aiState[step] ?? 'Auto';
                  return _ModelSelectionButton(
                    step: step,
                    modelName: activeModel,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ModelSelectionScreen(step: step)),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Pillar 2: Audio Processing Mode Section
              _buildSectionHeader(context, 'Audio Processing Mode (1 Stage)'),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AudioProcessingModeScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE65100), Color(0xFFFF9800)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.audiotrack_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1-Stage Audio Pipeline',
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Direct processing and voice transcription. Tap to see how it works.',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withValues(alpha: 0.7), size: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ResponsiveGridBuilder(
                mobileCrossAxisCount: 1,
                tabletCrossAxisCount: 1,
                desktopCrossAxisCount: 1,
                childAspectRatio: 4.5,
                children: audioStages.map((step) {
                  final activeModel = aiState[step] ?? 'Auto';
                  return _ModelSelectionButton(
                    step: step,
                    modelName: activeModel,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ModelSelectionScreen(step: step)),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Aggregate Statistics Section
              _buildSectionHeader(context, 'Overall AI Statistics'),
              const SizedBox(height: 12),

              allModelsAsync.when(
                data: (models) => _buildGlobalStatsSection(context, models),
                loading: () => const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
                error: (e, _) => Text('Error loading model statistics: $e', style: const TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = AdditionalWindowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: theme.mutedText,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildGlobalStatsSection(BuildContext context, List<AiModel> models) {
    final theme = AdditionalWindowTheme.of(context);

    int totalSuccess = 0;
    int totalPartial = 0;
    int totalError = 0;
    int totalRequests = 0;

    for (final m in models) {
      totalSuccess += m.successCount;
      totalPartial += m.partialSuccessCount;
      totalError += m.errorCount;
    }
    totalRequests = totalSuccess + totalPartial + totalError;

    if (totalRequests == 0) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: const Text(
          'No AI requests processed yet. Statistics will appear here.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      );
    }

    final successRate = ((totalSuccess + totalPartial) / totalRequests * 100).toStringAsFixed(1);

    // Sort models by usage count to display active distribution chart
    final usedModels = models.where((m) => (m.successCount + m.partialSuccessCount + m.errorCount) > 0).toList()
      ..sort((a, b) {
        final totalA = a.successCount + a.partialSuccessCount + a.errorCount;
        final totalB = b.successCount + b.partialSuccessCount + b.errorCount;
        return totalB.compareTo(totalA);
      });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  painter: _PieChartPainter(
                    success: totalSuccess.toDouble(),
                    partial: totalPartial.toDouble(),
                    error: totalError.toDouble(),
                  ),
                  child: Center(
                    child: Text(
                      '$successRate%',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.titleColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Global Performance Summary',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.titleColor),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildStatBadge(context, 'Success: $totalSuccess', Colors.teal),
                        _buildStatBadge(context, 'Partial: $totalPartial', Colors.amber),
                        _buildStatBadge(context, 'Errors: $totalError', totalError > 0 ? Colors.redAccent : theme.mutedText),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total requests across all models: $totalRequests',
                      style: TextStyle(fontSize: 12, color: theme.mutedText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (usedModels.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'MODEL USAGE DISTRIBUTION',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.mutedText, letterSpacing: 0.8),
            ),
            const SizedBox(height: 14),
            ...usedModels.map((model) {
              final modelTotal = model.successCount + model.partialSuccessCount + model.errorCount;
              final sharePercent = (modelTotal / totalRequests);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            model.name,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.titleColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '$modelTotal req (${(sharePercent * 100).toStringAsFixed(0)}%)',
                          style: TextStyle(fontSize: 12, color: theme.mutedText, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: sharePercent,
                        backgroundColor: theme.dividerColor,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primaryAccent),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildStatBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}

class _ModelSelectionButton extends StatelessWidget {
  final TranslationPipelineStep step;
  final String modelName;
  final VoidCallback onTap;

  const _ModelSelectionButton({
    required this.step,
    required this.modelName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  step == TranslationPipelineStep.transcribe ? Icons.audiotrack_rounded : Icons.article_rounded,
                  size: 14,
                  color: theme.mutedText,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    step.displayName.toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: theme.mutedText, letterSpacing: 0.4),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              modelName,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.primaryAccent),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final double success;
  final double partial;
  final double error;

  _PieChartPainter({
    required this.success,
    required this.partial,
    required this.error,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = success + partial + error;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;

    if (total <= 0) {
      paint.color = Colors.grey.withValues(alpha: 0.3);
      canvas.drawCircle(center, radius, paint);
      return;
    }

    double startAngle = -90 * 3.1415926535 / 180;

    if (success > 0) {
      final sweepAngle = (success / total) * 2 * 3.1415926535;
      paint.color = Colors.teal;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }

    if (partial > 0) {
      final sweepAngle = (partial / total) * 2 * 3.1415926535;
      paint.color = Colors.amber;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }

    if (error > 0) {
      final sweepAngle = (error / total) * 2 * 3.1415926535;
      paint.color = Colors.redAccent;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
