import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/services/anilist_service.dart';
import 'package:eiga/backend/services/jimaku_service.dart';
import 'package:eiga/backend/services/tvmaze_service.dart';
import 'package:eiga/backend/services/shikimori_service.dart';
import 'package:eiga/backend/services/anki_service.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';

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

final ankiServiceProvider = Provider<AnkiService>((ref) {
  final config = ref.watch(appConfigsServiceProvider);
  return AnkiService(config);
});
