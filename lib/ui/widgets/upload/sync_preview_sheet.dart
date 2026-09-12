import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../styles/app_colors.dart';
import '../../styles/additional_window_theme.dart';

class SyncPreviewSheet extends StatefulWidget {
  final String videoPath;
  final List<Phrase> phrases;

  const SyncPreviewSheet({
    super.key,
    required this.videoPath,
    required this.phrases,
  });

  @override
  State<SyncPreviewSheet> createState() => _SyncPreviewSheetState();
}

class _SyncPreviewSheetState extends State<SyncPreviewSheet> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  int _currentPhraseIndex = 0;
  String _activeSubtitle = '';
  bool _isManualSeeking = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _controller = VideoPlayerController.file(File(widget.videoPath));
    try {
      await _controller.initialize();
      _controller.addListener(_onPositionChanged);
      setState(() => _isInitialized = true);
      
      if (widget.phrases.isNotEmpty) {
        _seekToPhrase(0);
      }
    } catch (e) {
      debugPrint('Error initializing preview player: $e');
    }
  }

  void _onPositionChanged() {
    if (!mounted || _isManualSeeking) return;
    
    final pos = _controller.value.position;
    final now = DateTime(1970, 1, 1);
    
    // Find matching phrase
    final matchIndex = widget.phrases.indexWhere((p) {
      if (p.startTime == null || p.endTime == null) return false;
      final start = p.startTime!.difference(now);
      final end = p.endTime!.difference(now);
      return pos >= start && pos <= end;
    });

    if (matchIndex != -1) {
      if (matchIndex != _currentPhraseIndex || _activeSubtitle.isEmpty) {
        setState(() {
          _currentPhraseIndex = matchIndex;
          _activeSubtitle = widget.phrases[matchIndex].originalPhrase ?? '';
        });
      }
    } else {
      // If we are between phrases, we might want to keep the last one visible 
      // if it was just shown (short duration) or clear it.
      // For sync check, clearing is better to see gaps.
      if (_activeSubtitle.isNotEmpty) {
        setState(() => _activeSubtitle = '');
      }
    }
  }

  Future<void> _seekToPhrase(int index) async {
    if (index < 0 || index >= widget.phrases.length) return;
    
    final startTime = widget.phrases[index].startTime;
    if (startTime != null) {
      final now = DateTime(1970, 1, 1);
      final offset = startTime.difference(now);
      
      setState(() {
        _isManualSeeking = true;
        _currentPhraseIndex = index;
        _activeSubtitle = widget.phrases[index].originalPhrase ?? '';
      });

      await _controller.seekTo(offset);
      
      // Small delay to let player settle before resuming auto-tracking
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) setState(() => _isManualSeeking = false);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPositionChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
            child: Row(
              children: [
                Icon(Icons.preview_rounded, color: theme.primaryAccent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sync Preview',
                    style: TextStyle(color: theme.titleColor, fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, color: theme.mutedText),
                ),
              ],
            ),
          ),

          // Video Area
          Container(
            width: double.infinity,
            height: 240,
            color: Colors.black,
            child: _isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),

          // Subtitle Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: theme.isDark ? Colors.white.withOpacity(0.05) : AppColors.slate50,
            child: Text(
              _activeSubtitle.isEmpty ? '(No audio detected here)' : _activeSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _activeSubtitle.isEmpty ? theme.mutedText : theme.normalText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontStyle: _activeSubtitle.isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),

          // Controls Area
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ControlBtn(
                      icon: Icons.skip_previous_rounded,
                      onTap: () => _seekToPhrase(_currentPhraseIndex - 1),
                      enabled: _currentPhraseIndex > 0,
                      theme: theme,
                    ),
                    const SizedBox(width: 32),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying ? _controller.pause() : _controller.play();
                        });
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: theme.primaryAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryAccent.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Icon(
                          _controller.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    _ControlBtn(
                      icon: Icons.skip_next_rounded,
                      onTap: () => _seekToPhrase(_currentPhraseIndex + 1),
                      enabled: _currentPhraseIndex < widget.phrases.length - 1,
                      theme: theme,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Phrase ${_currentPhraseIndex + 1} of ${widget.phrases.length}',
                  style: TextStyle(color: theme.mutedText, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final AdditionalWindowTheme theme;

  const _ControlBtn({required this.icon, required this.onTap, this.enabled = true, required this.theme});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(
        icon, 
        color: enabled ? theme.titleColor : theme.mutedText.withOpacity(0.3), 
        size: 32
      ),
    );
  }
}
