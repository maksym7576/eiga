import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'dart:developer' as developer;
import 'ui/dto_providers.dart';
import 'ui/search_provider.dart';

enum ProviderStatus {
  online,
  error,
}

// Map between UI service status and internal provider status
ServiceStatus mapToServiceStatus(ProviderStatus status) {
  switch (status) {
    case ProviderStatus.online:
      return ServiceStatus.active;
    case ProviderStatus.error:
      return ServiceStatus.down;
  }
}

final providerStatusProvider = StateProvider.family<ProviderStatus, MetadataProviderType>(
    (ref, type) => ProviderStatus.online);

final providerStatusMessageProvider = StateProvider.family<String?, MetadataProviderType>(
    (ref, type) => null);

// Unified health check provider
final checkServiceProviderStatus = FutureProvider.family<void, MetadataProviderType>((ref, type) async {
  if (type == MetadataProviderType.manual) return;

  try {
    bool isOnline = true;
    String? message;

    if (type == MetadataProviderType.anilist) {
      final service = ref.read(aniListServiceProvider);
      final health = await service.checkHealth();
      isOnline = health.$1;
      message = health.$2;
    } else if (type == MetadataProviderType.shikimori) {
      final service = ref.read(shikimoriServiceProvider);
      final health = await service.checkHealth();
      isOnline = health.$1;
      message = health.$2;
    } else if (type == MetadataProviderType.tvmaze) {
      final service = ref.read(tvMazeServiceProvider);
      final health = await service.checkHealth();
      isOnline = health.$1;
      message = health.$2;
    }

    if (isOnline) {
      developer.log('${type.name} health check: ONLINE', name: 'ServiceStatus');
      ref.read(providerStatusProvider(type).notifier).state = ProviderStatus.online;
      ref.read(providerStatusMessageProvider(type).notifier).state = null;
    } else {
      developer.log('${type.name} health check: OFFLINE. Msg: $message', name: 'ServiceStatus');
      ref.read(providerStatusProvider(type).notifier).state = ProviderStatus.error;
      ref.read(providerStatusMessageProvider(type).notifier).state = message;
    }
  } catch (e) {
    developer.log('${type.name} health check failed: $e', name: 'ServiceStatus');
    ref.read(providerStatusProvider(type).notifier).state = ProviderStatus.error;
  }
});
