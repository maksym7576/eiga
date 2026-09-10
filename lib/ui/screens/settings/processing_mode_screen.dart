import 'package:flutter/material.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';

class ProcessingModeScreen extends StatelessWidget {
  const ProcessingModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Processing Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModeHeader(context),
            const SizedBox(height: 32),
            _buildStageItem(context, 1, 'Research', 'AI analyzes the context (anime title, season, episode) to provide accurate translations.'),
            _buildConnector(context),
            _buildStageItem(context, 2, 'Translation', 'Clean literary translation based on context and running glossary.'),
            _buildConnector(context),
            _buildStageItem(context, 3, 'Tokenization', 'Splitting text into individual words using Local logic or AI.'),
            _buildConnector(context),
            _buildStageItem(context, 4, 'Morphology', 'Linguistic analysis, base forms, and semantic alignment.'),
          ],
        ),
      ),
    );
  }

  Widget _buildModeHeader(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandBlue, AppColors.brandBlue.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 32),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '4-Stage Advanced',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
                SizedBox(height: 4),
                Text(
                  'Maximum quality and depth of analysis.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageItem(BuildContext context, int index, String title, String description) {
    final theme = AdditionalWindowTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.primaryAccent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$index',
              style: TextStyle(color: theme.primaryAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.titleColor)),
              const SizedBox(height: 4),
              Text(description, style: TextStyle(fontSize: 12, color: theme.mutedText, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(left: 15),
      height: 24,
      width: 2,
      color: theme.dividerColor,
    );
  }
}
