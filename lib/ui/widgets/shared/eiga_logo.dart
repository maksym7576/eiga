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
      duration: const Duration(milliseconds: 5000), // Longer duration for full round-trip
    );

    // Full round-trip sequence:
    // 0 - 20%: eiga visible
    // 20 - 30%: i, g, a fade out & move up
    // 30 - 40%: i, g, あ fade in & move down
    // 40 - 70%: eigあ visible
    // 70 - 80%: i, g, あ fade out & move up
    // 80 - 90%: i, g, a fade in & move down
    // 90 - 100%: pause at start

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 10),
    ]).animate(_controller);

    _translateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -20.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: -20.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -20.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: -20.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10),
    ]).animate(_controller);

    _controller.addListener(() {
      // Toggle Kanji state during the "invisible" phases
      // First phase (30% to 70%): show Kanji
      if (_controller.value >= 0.3 && _controller.value <= 0.7 && !_showKanji) {
        setState(() => _showKanji = true);
      } 
      // Second phase (after 80% or before 20%): show Latin 'a'
      else if ((_controller.value > 0.8 || _controller.value < 0.2) && _showKanji) {
        setState(() => _showKanji = false);
      }
    });

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
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
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
                    // Stable container for the last character
                    Baseline(
                      baseline: widget.size * 0.8, // Estimate baseline position
                      baselineType: TextBaseline.alphabetic,
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        clipBehavior: Clip.none,
                        children: [
                          // Invisible placeholder to keep the width stable (using 'あ' as it's wider)
                          Opacity(
                            opacity: 0,
                            child: Text('あ', style: textStyle),
                          ),
                          // The actual character, positioned to match the baseline
                          Text(
                            _showKanji ? 'あ' : 'a',
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
      ],
    );
  }
}
