import 'dart:async';
import 'package:flutter/material.dart';

class EigaLogoAnimation extends StatefulWidget {
  final TextStyle style;

  const EigaLogoAnimation({super.key, required this.style});

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
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _runAnimation();
    });
    // Initial run after a short delay
    Future.delayed(const Duration(seconds: 2), _runAnimation);
  }

  void _runAnimation() async {
    if (!mounted) return;

    // 1. Плавне згортання (1.0 -> 0.0)
    await _controller.forward();
    if (!mounted) return;

    // 2. Міняємо літеру, поки бокс невидимий
    setState(() => _currentLetter = 'あ');
    
    // Невелика пауза в невидимому стані для плавності
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // 3. Розгортання з новою літерою (0.0 -> 1.0)
    await _controller.reverse();

    // 4. Пауза з японською літерою
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // 5. Згортання 'あ' (1.0 -> 0.0)
    await _controller.forward();
    if (!mounted) return;

    // 6. Повертаємо 'a'
    setState(() => _currentLetter = 'a');
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // 7. Розгортання 'a' (0.0 -> 1.0)
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
