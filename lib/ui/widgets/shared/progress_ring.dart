import 'dart:math';
import 'package:flutter/material.dart';

class ProgressRing extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color inactiveColor;
  final TextStyle? textStyle;
  final bool isAnimating;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 44,
    this.strokeWidth = 3.5,
    this.inactiveColor = const Color(0xFF2A2A38),
    this.textStyle,
    this.isAnimating = false,
  });

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing> with TickerProviderStateMixin {
  late AnimationController _opacityController;
  late AnimationController _colorController;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    if (widget.isAnimating) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _opacityController.repeat(reverse: true);
    _colorController.repeat();
  }

  void _stopAnimations() {
    _opacityController.stop();
    _colorController.stop();
    _opacityController.value = 1.0;
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Color _getCurrentColor(double t) {
    // 0: #7c86ff, 0.33: #5ad1e6, 0.66: #b07cff, 1.0: #7c86ff
    const c1 = Color(0xFF7C86FF);
    const c2 = Color(0xFF5AD1E6);
    const c3 = Color(0xFFB07CFF);

    if (t < 0.33) {
      return Color.lerp(c1, c2, t / 0.33)!;
    } else if (t < 0.66) {
      return Color.lerp(c2, c3, (t - 0.33) / 0.33)!;
    } else {
      return Color.lerp(c3, c1, (t - 0.66) / 0.34)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_opacityController, _colorController]),
      builder: (context, child) {
        final activeColor = widget.isAnimating 
            ? _getCurrentColor(_colorController.value)
            : const Color(0xFF3B66F5);
            
        final opacity = widget.isAnimating 
            ? 0.35 + (_opacityController.value * 0.65)
            : 1.0;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Inner Background Knob Circle
              Container(
                width: widget.size,
                height: widget.size,
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C28),
                  shape: BoxShape.circle,
                ),
              ),
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ProgressRingPainter(
                  progress: widget.progress,
                  strokeWidth: widget.strokeWidth,
                  activeColor: activeColor.withOpacity(opacity),
                  inactiveColor: widget.inactiveColor,
                ),
              ),
              Text(
                '${(widget.progress * 100).toInt()}%',
                style: widget.textStyle ??
                    const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                      height: 1.0,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color activeColor;
  final Color inactiveColor;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle (Track)
    final backgroundPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // Start from top
        2 * pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
