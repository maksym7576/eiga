import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/ui/widgets/appBarWidgets/app_app_bar.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const AppAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Video Library Content'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push('/player'),
              child: const Text('Open Video Player'),
            ),
          ],
        ),
      ),
    );
  }
}
