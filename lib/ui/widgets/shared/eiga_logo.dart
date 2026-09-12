import 'dart:async';
import 'package:flutter/material.dart';

class EigaLogo extends StatefulWidget {
  final double size;
  final Color color;
  final bool isFrequent;

  const EigaLogo({
    super.key,
    this.size = 56,
    this.color = const Color(0xFF185FA5),
    this.isFrequent = false,
  });

  @override
  State<EigaLogo> createState() => _EigaLogoState();
}

class _EigaLogoState extends State<EigaLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 20),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 20),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
    ]).animate(_controller);

    final translateOffset = widget.size * 0.35;

    _translateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -translateOffset).chain(CurveTween(curve: Curves.easeOut)), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: -translateOffset, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 20),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -translateOffset).chain(CurveTween(curve: Curves.easeOut)), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: -translateOffset, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 20),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 60),
    ]).animate(_controller);

    if (widget.isFrequent) {
      _controller.repeat();
    } else {
      _startToggleCycle();
    }
  }

  void _startToggleCycle() {
    bool toKanji = true;
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (toKanji) {
        _controller.animateTo(0.5);
      } else {
        _controller.animateTo(1.0).then((_) {
          if (mounted) _controller.value = 0.0;
        });
      }
      toKanji = !toKanji;
    });
    
    // Initial toggle
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _controller.animateTo(0.5);
        toKanji = false;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: widget.size,
      fontWeight: FontWeight.w700,
      color: widget.color,
      fontFamily: 'Arial',
      height: 1.0, 
      leadingDistribution: TextLeadingDistribution.even,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('e', style: textStyle),
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Determine which character to show based on the current progress
              // Switch to Kanji after the first fade-out/move-up (at 10%)
              // Switch back to Latin after the second fade-out/move-up (at 60%)
              final bool showKanji = _controller.value >= 0.1 && _controller.value <= 0.6;

              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _translateAnimation.value),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('i', style: textStyle),
                      Text('g', style: textStyle),
                      Baseline(
                        baseline: widget.size * 0.8,
                        baselineType: TextBaseline.alphabetic,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          clipBehavior: Clip.none,
                          children: [
                            Opacity(
                              opacity: 0,
                              child: Text('あ', style: textStyle),
                            ),
                            Text(
                              showKanji ? 'あ' : 'a',
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
