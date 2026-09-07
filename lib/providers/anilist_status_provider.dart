import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'dart:developer' as developer;
import 'ui/dto_providers.dart';

enum AniListStatus {
  online,
  maintenance,
  error,
}

final aniListStatusProvider = StateProvider<AniListStatus>((ref) => AniListStatus.online);
final aniListStatusMessageProvider = StateProvider<String?>((ref) => null);

final checkAniListStatusProvider = FutureProvider<void>((ref) async {
  final service = ref.read(aniListServiceProvider);
  final health = await service.checkHealth();
  final isOnline = health.$1;
  final message = health.$2;
  
  if (isOnline) {
    developer.log('AniList health check: ONLINE', name: 'AniListService');
    ref.read(aniListStatusProvider.notifier).state = AniListStatus.online;
    ref.read(aniListStatusMessageProvider.notifier).state = null;
  } else {
    developer.log('AniList health check: OFFLINE/STABILITY ISSUE. Message: $message', name: 'AniListService');
    // We default to error if health check fails, 
    // but specific API calls might set it to maintenance if they see specific error messages
    ref.read(aniListStatusProvider.notifier).state = AniListStatus.error;
    ref.read(aniListStatusMessageProvider.notifier).state = message;
    
    if (message != null && message.contains('temporarily disabled')) {
      ref.read(aniListStatusProvider.notifier).state = AniListStatus.maintenance;
    }
  }
});
