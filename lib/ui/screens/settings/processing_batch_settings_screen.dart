import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/services/app_configs_provider.dart';
import '../../styles/additional_window_theme.dart';

class ProcessingBatchSettingsScreen extends ConsumerWidget {
  const ProcessingBatchSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final config = ref.watch(appConfigsServiceProvider);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Batch Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: theme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoBox(context),
          const SizedBox(height: 24),
          _BatchInputTile(
            title: 'Collection Limit',
            subtitle: 'Number of phrases to collect before triggering AI',
            value: config.getNumberOfPhrases,
            onChanged: (val) => config.setNumberOfPhrases(val),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Per-Stage Batch Limits'),
          const SizedBox(height: 12),
          _BatchInputTile(
            title: 'Translation Batch Size',
            subtitle: 'Number of phrases per translation request',
            value: config.getBatchSizeTranslate,
            onChanged: (val) => config.setBatchSizeTranslate(val),
          ),
          const SizedBox(height: 12),
          _BatchInputTile(
            title: 'Tokenization Batch Size',
            subtitle: 'Number of phrases per AI tokenization request',
            value: config.getBatchSizeTokenize,
            onChanged: (val) => config.setBatchSizeTokenize(val),
          ),
          const SizedBox(height: 12),
          _BatchInputTile(
            title: 'Morphology Batch Size',
            subtitle: 'Number of phrases per morphology analysis request',
            value: config.getBatchSizeMorphemes,
            onChanged: (val) => config.setBatchSizeMorphemes(val),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = AdditionalWindowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: theme.mutedText,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Smaller batch sizes are more stable but result in more requests. Recommended: 20-40.',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ),
        ],
      ),
    );
  }
}

class _BatchInputTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final Function(int) onChanged;

  const _BatchInputTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.titleColor)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: theme.mutedText)),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: TextField(
              controller: TextEditingController(text: value.toString()),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (val) {
                final n = int.tryParse(val);
                if (n != null && n > 0) onChanged(n);
              },
            ),
          ),
        ],
      ),
    );
  }
}
