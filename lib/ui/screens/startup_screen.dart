import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/shared/loading_splash.dart';
import 'package:eiga/providers/ui/redirect_providers.dart';

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
    print('StartupScreen: Starting 3 seconds delay...');
    await Future.delayed(const Duration(seconds: 3));
    print('StartupScreen: Delay complete. Mounted: $mounted');
    if (mounted) {
      try {
        print('StartupScreen: Navigating to /main...');
        context.go('/main');
        print('StartupScreen: Navigation call successful.');
      } catch (e, stack) {
        print('StartupScreen: Error during navigation: $e');
        print(stack);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final useAlternative = ref.watch(useAlternativeLogoProvider);
    return LoadingSplash(useAlternativeLogo: useAlternative);
  }
}
