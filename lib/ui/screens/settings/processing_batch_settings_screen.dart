import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import '../../styles/additional_window_theme.dart';

class ProcessingBatchSettingsScreen extends ConsumerStatefulWidget {
  const ProcessingBatchSettingsScreen({super.key});

  @override
  ConsumerState<ProcessingBatchSettingsScreen> createState() => _ProcessingBatchSettingsScreenState();
}

class _ProcessingBatchSettingsScreenState extends ConsumerState<ProcessingBatchSettingsScreen> {
  int _resetCounter = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final config = ref.watch(appConfigsServiceProvider);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Batch Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: theme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Reset to defaults',
            onPressed: () async {
              await config.resetBatchSettings();
              setState(() {
                _resetCounter++;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        key: ValueKey(_resetCounter),
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoBox(context),
          const SizedBox(height: 24),
          _BatchInputTile(
            key: ValueKey('phrases_$_resetCounter'),
            title: 'Collection Limit',
            subtitle: 'Number of phrases to collect before triggering AI',
            value: config.getNumberOfPhrases,
            onChanged: (val) async {
              await config.setNumberOfPhrases(val);
              setState(() {});
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Per-Stage Batch Limits'),
          const SizedBox(height: 12),
          _BatchInputTile(
            key: ValueKey('translate_$_resetCounter'),
            title: 'Translation Batch Size',
            subtitle: 'Number of phrases per translation request',
            value: config.getBatchSizeTranslate,
            onChanged: (val) async {
              await config.setBatchSizeTranslate(val);
              setState(() {});
            },
          ),
          const SizedBox(height: 12),
          _BatchInputTile(
            key: ValueKey('tokenize_$_resetCounter'),
            title: 'Tokenization Batch Size',
            subtitle: 'Number of phrases per AI tokenization request',
            value: config.getBatchSizeTokenize,
            onChanged: (val) async {
              await config.setBatchSizeTokenize(val);
              setState(() {});
            },
          ),
          const SizedBox(height: 12),
          _BatchInputTile(
            key: ValueKey('morphemes_$_resetCounter'),
            title: 'Morphology Batch Size',
            subtitle: 'Number of phrases per morphology analysis request',
            value: config.getBatchSizeMorphemes,
            onChanged: (val) async {
              await config.setBatchSizeMorphemes(val);
              setState(() {});
            },
          ),
          const SizedBox(height: 12),
          _BatchInputTile(
            key: ValueKey('grammar_$_resetCounter'),
            title: 'Grammar & Connections Batch Size',
            subtitle: 'Number of phrases per sentence diagram request',
            value: config.getBatchSizeGrammarRole,
            onChanged: (val) async {
              await config.setBatchSizeGrammarRole(val);
              setState(() {});
            },
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

class _BatchInputTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final int value;
  final Function(int) onChanged;

  const _BatchInputTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_BatchInputTile> createState() => _BatchInputTileState();
}

class _BatchInputTileState extends State<_BatchInputTile> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(_BatchInputTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && _controller.text != widget.value.toString()) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                Text(widget.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.titleColor)),
                const SizedBox(height: 2),
                Text(widget.subtitle, style: TextStyle(fontSize: 11, color: theme.mutedText)),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) {
                final n = int.tryParse(val);
                if (n != null && n > 0) widget.onChanged(n);
              },
              onSubmitted: (val) {
                final n = int.tryParse(val);
                if (n != null && n > 0) widget.onChanged(n);
              },
            ),
          ),
        ],
      ),
    );
  }
}
