import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/shared/loading_splash.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _startTransition();
  }

  Future<void> _startTransition() async {
    // Show animation for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingSplash();
  }
}
