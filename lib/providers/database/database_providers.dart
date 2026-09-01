import 'package:isar_community/isar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/services/isar_service.dart';
import 'package:eiga/backend/database/services/ai_model_service.dart';
import 'package:eiga/backend/database/services/video_service.dart';

/// Provider for the Isar instance.
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider must be overridden');
});

/// Provider for IsarService.
final isarServiceProvider = Provider<IsarService>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarService(isar);
});

/// Provider for AiModelService.
final aiModelServiceProvider = Provider<AiModelService>((ref) {
  final isar = ref.watch(isarProvider);
  return AiModelService(isar);
});

/// Provider for VideoService.
final videoServiceProvider = Provider<VideoService>((ref) {
  final isar = ref.watch(isarProvider);
  return VideoService(isar);
});
