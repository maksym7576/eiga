import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/shared/loading_splash.dart';
import '../../providers/ui/redirect_providers.dart';

class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends ConsumerState<StartupScreen> {
  @override
  void initState() {
    super.initState();
    // Reinforce status bar visibility
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    // Initialize session-wide logo style
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(useAlternativeLogoProvider.notifier).state = Random().nextBool();
    });
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
    final useAlternative = ref.watch(useAlternativeLogoProvider);
    return LoadingSplash(useAlternativeLogo: useAlternative);
  }
}
