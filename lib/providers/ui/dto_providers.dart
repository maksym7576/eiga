import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import 'package:eiga/backend/database/dto/anilist_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_dto.dart';
import 'package:eiga/backend/services/anilist_service.dart';
import 'package:eiga/backend/services/jimaku_service.dart';

final aniListServiceProvider = Provider<AniListService>((ref) {
  return AniListService();
});

final jimakuServiceProvider = FutureProvider<JimakuService>((ref) async {
  return JimakuService.create();
});

class AniListNotifier extends AsyncNotifier<AniListDataDTO?> {
  @override
  Future<AniListDataDTO?> build() async {
    return null;
  }

  Future<void> load(int anilistId, {bool downloadImages = false}) async {
    final service = ref.read(aniListServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => service.getById(anilistId, downloadImages: downloadImages),
    );
  }

  Future<void> refresh(int anilistId) async {
    await load(anilistId, downloadImages: true);
  }

  void clear() {
    state = const AsyncData(null);
  }
}

final aniListProvider = AsyncNotifierProvider<AniListNotifier, AniListDataDTO?>(
  AniListNotifier.new,
);

final jimakuEntryFinalProvider = StateProvider<JimakuDataDTO?>((ref) => null);
final jimakuFileFinalProvider = StateProvider<FileJimakuDTO?>((ref) => null);
