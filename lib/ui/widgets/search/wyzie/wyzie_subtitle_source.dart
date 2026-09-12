import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/backend/services/wyzie_service.dart';
import 'package:eiga/backend/services/utils/jimaku_clustering_util.dart';
import 'package:eiga/providers/ui/dto_providers.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/wyzie_files_provider.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import '../jimaku/jimaku_file_tile.dart';

class WyzieSubtitleSource
    implements SearchSource<UnifiedMetadataDTO, JimakuFileOrGroupDTO> {
  @override
  String get key => SearchSourceKeys.wyzie;

  @override
  String get title => 'Subtitles (Wyzie)';

  @override
  String get searchHint => 'Search anime or movie on Wyzie...';

  @override
  bool get hasFileStage => false; 

  @override
  Map<String, dynamic> get defaultFilters => {
        'animeOnly': true,
      };

  Future<WyzieService> _service(WidgetRef ref) {
    return ref.read(wyzieServiceProvider.future);
  }

  @override
  Future<List<UnifiedMetadataDTO>> search(String query, Map<String, dynamic> filters, WidgetRef ref) async {
    final service = await _service(ref);
    final results = await service.searchWyzieObjects(
      query: query,
      anime: filters['animeOnly'] as bool? ?? true,
    );

    return results;
  }

  @override
  Future<List<dynamic>> fetchNextPage(String query, int page, Map<String, dynamic> filters, WidgetRef ref) async {
    return []; // Wyzie placeholder for pagination if needed
  }

  @override
  Future<String> resolve(dynamic selected, WidgetRef ref) async {
    final entry = selected as UnifiedMetadataDTO;
    final service = await _service(ref);
    final files = await service.getFiles(entry.sourceId);
    if (files.isEmpty) {
      throw Exception('No subtitle files found on Wyzie');
    }
    return service.downloadAndCacheFile(files.first.url, preferredName: files.first.name);
  }

  @override
  Widget buildFilterBar(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildFileCard(JimakuFileOrGroupDTO item, bool isActive, VoidCallback onTap) {
    return const SizedBox.shrink();
  }

  @override
  String entryId(UnifiedMetadataDTO entry) => entry.sourceId;

  @override
  String fileId(JimakuFileOrGroupDTO file) => file.id;

  @override
  String entryLabel(UnifiedMetadataDTO entry) => entry.title;
}
