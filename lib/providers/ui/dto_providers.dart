import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/backend/services/anilist_service.dart';
import 'package:eiga/backend/services/jimaku_service.dart';
import 'package:eiga/backend/services/tvmaze_service.dart';
import 'package:eiga/backend/services/shikimori_service.dart';
import 'package:eiga/backend/services/wyzie_service.dart';

final aniListServiceProvider = Provider<AniListService>((ref) {
  return AniListService();
});

final tvMazeServiceProvider = Provider<TVmazeService>((ref) {
  return TVmazeService();
});

final shikimoriServiceProvider = Provider<ShikimoriService>((ref) {
  return ShikimoriService();
});

final jimakuServiceProvider = FutureProvider<JimakuService>((ref) async {
  return JimakuService.create();
});

final wyzieServiceProvider = FutureProvider<WyzieService>((ref) async {
  return WyzieService.create();
});

class AniListNotifier extends AsyncNotifier<UnifiedMetadataDTO?> {
  @override
  Future<UnifiedMetadataDTO?> build() async {
    return null;
  }

  Future<void> load(int anilistId, {bool downloadImages = false}) async {
    final service = ref.read(aniListServiceProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => service.getById(anilistId, downloadImages: downloadImages),
    );
    
    if (result.hasError) {
      // ignore: avoid_print
      print('AniListNotifier: Error loading ID $anilistId: ${result.error}');
    }
    
    state = result;
  }

  Future<void> refresh(int anilistId) async {
    await load(anilistId, downloadImages: true);
  }

  void updateData(UnifiedMetadataDTO data) {
    state = AsyncData(data);
  }

  void clear() {
    state = const AsyncData(null);
  }
}

final aniListProvider = AsyncNotifierProvider<AniListNotifier, UnifiedMetadataDTO?>(
  AniListNotifier.new,
);

class TVmazeNotifier extends AsyncNotifier<UnifiedMetadataDTO?> {
  @override
  Future<UnifiedMetadataDTO?> build() async {
    return null;
  }

  Future<void> load(int tvmazeId, {bool downloadImages = false}) async {
    final service = ref.read(tvMazeServiceProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => service.getShowById(tvmazeId, downloadImage: downloadImages),
    );

    if (result.hasError) {
      // ignore: avoid_print
      print('TVmazeNotifier: Error loading ID $tvmazeId: ${result.error}');
    }

    state = result;
  }

  Future<void> refresh(int tvmazeId) async {
    await load(tvmazeId, downloadImages: true);
  }

  void updateData(UnifiedMetadataDTO data) {
    state = AsyncData(data);
  }

  void clear() {
    state = const AsyncData(null);
  }
}

final tvMazeProvider = AsyncNotifierProvider<TVmazeNotifier, UnifiedMetadataDTO?>(
  TVmazeNotifier.new,
);

class ShikimoriNotifier extends AsyncNotifier<UnifiedMetadataDTO?> {
  @override
  Future<UnifiedMetadataDTO?> build() async {
    return null;
  }

  Future<void> load(int id, {bool downloadImages = false}) async {
    final service = ref.read(shikimoriServiceProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => service.getAnimeById(id, downloadImages: downloadImages));
    state = result;
  }

  Future<void> refresh(int id) async {
    await load(id, downloadImages: true);
  }

  void updateData(UnifiedMetadataDTO data) {
    state = AsyncData(data);
  }

  void clear() {
    state = const AsyncData(null);
  }
}

final shikimoriProvider = AsyncNotifierProvider<ShikimoriNotifier, UnifiedMetadataDTO?>(
  ShikimoriNotifier.new,
);

final jimakuEntryFinalProvider = StateProvider<UnifiedMetadataDTO?>((ref) => null);
final jimakuFileFinalProvider = StateProvider<FileJimakuDTO?>((ref) => null);
