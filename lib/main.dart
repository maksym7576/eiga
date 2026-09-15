import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'dart:io';

import 'package:eiga/backend/database/services/isar_service.dart';
import 'package:eiga/providers/database/isar_providers.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/ui/navigators/router.dart';
import 'package:eiga/ui/widgets/ai_error_overlay.dart';
import 'package:eiga/ui/widgets/global_hint_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 800),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.maximize(); // Maximized on startup
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Set system UI to visible by default
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Default for light theme
  ));
  
  // Initialize Isar and Seeding
  final isar = await IsarService.openIsar();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Eiga',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      builder: (context, child) {
        return GlobalHintOverlay(
          child: AiErrorOverlay(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
