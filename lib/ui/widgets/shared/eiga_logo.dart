import 'package:flutter/material.dart';

class EigaLogo extends StatefulWidget {
  final double size;
  final Color color;

  const EigaLogo({
    super.key,
    this.size = 56,
    this.color = const Color(0xFF185FA5),
  });

  @override
  State<EigaLogo> createState() => _EigaLogoState();
}

class _EigaLogoState extends State<EigaLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;
  
  bool _showKanji = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    // Sequence starting with immediate action:
    // 0 - 10%:  i, g, a fade out & move up (Transition to Kanji)
    // 10 - 20%: i, g, あ fade in & move down
    // 20 - 50%: eigあ visible (30% pause)
    // 50 - 60%: i, g, あ fade out & move up (Transition to Latin)
    // 60 - 70%: i, g, a fade in & move down
    // 70 - 100%: eiga visible (30% pause)

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 30),
    ]).animate(_controller);

    _translateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -20.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: -20.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -20.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: -20.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 30),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
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
