import 'package:flutter/material.dart';

class ShimmerText extends StatefulWidget {
  final Widget child;
  final List<Color> shimmerColors;
  final Duration duration;

  const ShimmerText({
    super.key,
    required this.child,
    this.shimmerColors = const [
      Color(0xFF0F172A), // slate-900 (base)
      Color(0xFF0F172A),
      Color(0xFF3B66F5), // brand-blue pulse
      Color(0xFF0F172A),
      Color(0xFF0F172A),
    ],
    this.shimmerStops,
    this.duration = const Duration(milliseconds: 2200),
    this.blendMode = BlendMode.srcIn,
  });

  final List<double>? shimmerStops;
  final BlendMode blendMode;

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: widget.blendMode,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.shimmerColors,
              stops: widget.shimmerStops ?? (widget.shimmerColors.length == 5 
                ? const [0.0, 0.35, 0.5, 0.65, 1.0] 
                : null),
              transform: _SlidingGradientTransform(offset: _controller.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double offset;

  const _SlidingGradientTransform({required this.offset});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final double t = (offset * 2.5) - 1.25;
    return Matrix4.translationValues(t * bounds.width, 0, 0);
  }
}
