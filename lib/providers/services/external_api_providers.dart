import 'package:hooks_riverpod/hooks_riverpod.dart';
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
