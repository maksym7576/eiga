import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppNavigator extends HookConsumerWidget {
  final StatefulNavigationShell navigationShell;
  
  const AppNavigator({
    super.key, 
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We removed the BottomNavigationBar and NavigationRail as requested.
    // The navigation shell is still preserved to keep the state of the screens.
    return Scaffold(
      body: navigationShell,
    );
  }
}
