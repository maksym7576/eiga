import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:developer' as developer;
import '../ui/search_provider.dart';
import 'external_api_providers.dart';

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

class ProviderStatusNotifier extends Notifier<ProviderStatus> {
  final MetadataProviderType arg;
  ProviderStatusNotifier(this.arg);
  
  @override
  ProviderStatus build() => ProviderStatus.online;
  
  @override
  set state(ProviderStatus value) => super.state = value;
}

final providerStatusProvider = NotifierProvider.family<ProviderStatusNotifier, ProviderStatus, MetadataProviderType>(
  ProviderStatusNotifier.new,
);

class ProviderStatusMessageNotifier extends Notifier<String?> {
  final MetadataProviderType arg;
  ProviderStatusMessageNotifier(this.arg);
  
  @override
  String? build() => null;
  
  @override
  set state(String? value) => super.state = value;
}

final providerStatusMessageProvider = NotifierProvider.family<ProviderStatusMessageNotifier, String?, MetadataProviderType>(
  ProviderStatusMessageNotifier.new,
);

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
