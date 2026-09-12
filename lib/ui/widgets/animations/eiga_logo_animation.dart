import 'dart:async';
import 'package:flutter/material.dart';

class EigaLogoAnimation extends StatefulWidget {
  final TextStyle style;
  final bool isFrequent;

  const EigaLogoAnimation({
    super.key, 
    required this.style,
    this.isFrequent = false,
  });

  @override
  State<EigaLogoAnimation> createState() => _EigaLogoAnimationState();
}

class _EigaLogoAnimationState extends State<EigaLogoAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  String _currentLetter = 'a';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startAnimationCycle();
  }

  void _startAnimationCycle() {
    if (widget.isFrequent) {
      _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
        _runFullCycle();
      });
      _runFullCycle(); 
    } else {
      _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        _toggleState();
      });
      Future.delayed(const Duration(seconds: 5), _toggleState);
    }
  }

  void _toggleState() async {
    if (!mounted) return;

    // 1. Collapse
    await _controller.forward();
    if (!mounted) return;

    // 2. Switch
    setState(() {
      _currentLetter = _currentLetter == 'a' ? 'あ' : 'a';
    });
    
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // 3. Expand
    await _controller.reverse();
  }

  void _runFullCycle() async {
    if (!mounted) return;

    // a -> あ
    await _controller.forward();
    if (!mounted) return;
    setState(() => _currentLetter = 'あ');
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    await _controller.reverse();

    // Pause
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // あ -> a
    await _controller.forward();
    if (!mounted) return;
    setState(() => _currentLetter = 'a');
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    await _controller.reverse();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.style.fontSize ?? 22;
    final boxSize = fontSize * 1.2;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'eig',
          style: widget.style,
        ),
        const SizedBox(width: 4),
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: boxSize,
            height: boxSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.style.color,
              borderRadius: BorderRadius.circular(boxSize * 0.2),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _currentLetter,
                key: ValueKey(_currentLetter),
                style: widget.style.copyWith(
                  color: Colors.white,
                  fontSize: fontSize * 0.85,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
