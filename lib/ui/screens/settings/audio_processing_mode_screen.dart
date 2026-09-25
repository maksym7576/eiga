import 'package:flutter/material.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';

class AudioProcessingModeScreen extends StatelessWidget {
  const AudioProcessingModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Audio Processing Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: theme.backgroundColor.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: theme.dividerColor, height: 1),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModeHeader(context),
                const SizedBox(height: 32),
                _buildStageItem(context, 1, 'Audio Submission & Voice Detection', 'The audio track is captured, analyzed via VAD (Voice Activity Detection), segmented, and sent directly to specialized AI transcription models to generate highly precise subtitle timestamps.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE65100).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.mic_none_rounded, color: Colors.white, size: 32),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1-Stage Audio Pipeline',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
                SizedBox(height: 4),
                Text(
                  'Direct voice stream to text processing.',
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
            color: Colors.orange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.orange.withValues(alpha: 0.2), width: 1),
          ),
          child: const Center(
            child: Text(
              '1',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.titleColor)),
              const SizedBox(height: 4),
              Text(description, style: TextStyle(fontSize: 12, color: theme.mutedText, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}
