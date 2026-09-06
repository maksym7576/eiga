import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../dialogs/app_bottom_sheet.dart';
import 'reading_type_selector_widget.dart';

enum _SettingsView { main, readingType }

class VideoSettingsSheet extends StatefulWidget {
  const VideoSettingsSheet({super.key});

  @override
  State<VideoSettingsSheet> createState() => _VideoSettingsSheetState();
}

class _VideoSettingsSheetState extends State<VideoSettingsSheet> {
  _SettingsView _currentView = _SettingsView.main;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _currentView == _SettingsView.main
          ? _buildMainView(context)
          : ReadingTypeSelectorWidget(
              onBack: () => setState(() => _currentView = _SettingsView.main),
            ),
    );
  }

  Widget _buildMainView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.brandBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Settings Items
          GestureDetector(
            onTap: () => setState(() => _currentView = _SettingsView.readingType),
            child: _buildSettingsItem(
              icon: Icons.menu_book_rounded,
              title: 'Reading Mode & Languages',
              subtitle: 'Original and translation (language, furigana, transcription)',
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingsItem(
            icon: Icons.closed_caption_rounded,
            title: 'Subtitle Display & Size',
            subtitle: 'Font size, line height, contrast settings',
          ),
          const SizedBox(height: 8),
          _buildSettingsItem(
            icon: Icons.auto_awesome_rounded,
            title: 'AI Translation History',
            subtitle: 'Request log, saved explanations, and grammar',
          ),
          const SizedBox(height: 8),
          _buildSettingsItem(
            icon: Icons.schedule_rounded,
            title: 'Subtitle Synchronization',
            subtitle: 'Adjust timings and sync with audio/video',
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Squircle Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.brandBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.brandBlue.withOpacity(0.15)),
            ),
            child: Icon(
              icon,
              size: 23,
              color: AppColors.brandBlue,
            ),
          ),
          const SizedBox(width: 14),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 19,
            color: Color(0xFFCBD5E1),
          ),
        ],
      ),
    );
  }
}
