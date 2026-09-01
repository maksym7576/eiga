import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eiga/ui/navigators/app_navigator.dart';
import 'package:eiga/ui/screens/main_screen.dart';
import 'package:eiga/ui/screens/upload_screen.dart';
import 'package:eiga/ui/screens/settings_screen.dart';
import 'package:eiga/ui/screens/video_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/main',
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppNavigator(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main',
              builder: (context, state) => const MainScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/upload',
              builder: (context, state) => const UploadScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    // Player is top-level to hide navigation shell completely
    GoRoute(
      path: '/player',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const VideoScreen(),
    ),
  ],
);
