import 'dart:developer' as developer;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/language_provider.dart';
import 'package:eiga/providers/ui/metadata_state_provider.dart';
import 'package:eiga/providers/services/isar_services_providers.dart';

class StateResetService {
  static void resetAll(Ref ref) {
    developer.log('StateResetService [PARAM TRACE]: resetAll() invoked', name: 'StateResetService');

    try {
      final oldPlayerId = ref.read(playerIdProvider);
      ref.read(playerIdProvider.notifier).state = null;
      developer.log('StateResetService [PARAM TRACE]: playerIdProvider reset from $oldPlayerId to null', name: 'StateResetService');

      ref.read(playerProvider('preview').notifier).disposeController();
      developer.log('StateResetService [PARAM TRACE]: preview player scope disposed', name: 'StateResetService');
    } catch (e) {
      developer.log('StateResetService [PARAM TRACE ERROR]: player/playerId reset error: $e', name: 'StateResetService');
    }

    try {
      ref.read(audioSyncServiceProvider).clearCache();
      developer.log('StateResetService [PARAM TRACE]: audioSyncServiceProvider cache cleared', name: 'StateResetService');
    } catch (e) {
      developer.log('StateResetService [PARAM TRACE ERROR]: audio sync cache error: $e', name: 'StateResetService');
    }

    try {
      ref.read(selectedEntryProvider(SearchSourceKeys.jimaku).notifier).state = null;
      ref.read(selectedEntryProvider(SearchSourceKeys.anilist).notifier).state = null;
      ref.read(selectedEntryProvider(SearchSourceKeys.shikimori).notifier).state = null;
      ref.read(selectedEntryProvider(SearchSourceKeys.tvmaze).notifier).state = null;
      developer.log('StateResetService [PARAM TRACE]: search selected entries cleared (jimaku, anilist, shikimori, tvmaze)', name: 'StateResetService');

      ref.read(jimakuSearchFullResultsProvider.notifier).state = [];
      developer.log('StateResetService [PARAM TRACE]: jimakuSearchFullResultsProvider cleared', name: 'StateResetService');

      ref.read(aniListProvider.notifier).clear();
      developer.log('StateResetService [PARAM TRACE]: aniListProvider cleared', name: 'StateResetService');
    } catch (e) {
      developer.log('StateResetService [PARAM TRACE ERROR]: search providers reset error: $e', name: 'StateResetService');
    }

    try {
      final oldLang = ref.read(languageProvider);
      ref.read(languageProvider.notifier).reset();
      developer.log('StateResetService [PARAM TRACE]: languageProvider reset from original=${oldLang.original}, target=${oldLang.target}', name: 'StateResetService');
    } catch (e) {
      developer.log('StateResetService [PARAM TRACE ERROR]: language provider reset error: $e', name: 'StateResetService');
    }

    developer.log('StateResetService [PARAM TRACE]: resetAll() completed', name: 'StateResetService');
  }
}
