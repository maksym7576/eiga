import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/providers/ui/search_provider.dart';

class EnrichedMetadata {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final int? episodes;
  final String? linkUrl;
  final bool isLoading;
  final bool hasFailed;
  final bool isEnriched;

  const EnrichedMetadata({
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.episodes,
    this.linkUrl,
    this.isLoading = false,
    this.hasFailed = false,
    this.isEnriched = false,
  });
}

/// A marker class used in the cache to indicate that a metadata lookup was 
/// performed but no data was found. This prevents infinite loading spinners.
class NoMetadataDTO {
  const NoMetadataDTO();
}

final metadataEnrichmentProvider = Provider.family.autoDispose<EnrichedMetadata, dynamic>((ref, entry) {
  if (entry is! UnifiedMetadataDTO) {
     return const EnrichedMetadata(title: 'Unknown');
  }

  final provider = ref.watch(selectedMetadataProvider);
  
  // 1. Basic properties from the entry itself
  String title = entry.title;
  String? subtitle = entry.subtitle;
  String? imageUrl = entry.imageUrl;
  int? episodes = entry.episodes;
  String? linkUrl = entry.linkUrl;

  // Identify external IDs
  int? anilistId = entry.anilistId;
  String? tmdbId = entry.tmdbId;
  String? imdbId = entry.imdbId;
  String? thetvdbId = entry.thetvdbId;
  
  // Check background analysis summary for Jimaku if applicable
  if (entry.linkUrl?.contains('jimaku.cc') == true) {
    final id = int.tryParse(entry.sourceId);
    if (id != null) {
      final summary = ref.watch(jimakuSummaryProvider(id));
      episodes = summary?.episodeCount ?? episodes;
    }
  }

  // 2. Enrich based on active provider
  // Find which search source this entry likely belongs to for cache lookup
  String sourceKey;
  if (entry.linkUrl?.contains('jimaku.cc') == true) {
    sourceKey = SearchSourceKeys.jimaku;
  } else if (entry.malId != null || entry.shikimoriId != null) {
    sourceKey = SearchSourceKeys.shikimori;
  } else if (entry.anilistId != null) {
    sourceKey = SearchSourceKeys.anilist;
  } else {
    sourceKey = SearchSourceKeys.tvmaze;
  }

  final searchMetadata = ref.watch(searchMetadataProvider(sourceKey));
  
  final id = int.tryParse(entry.sourceId);
  final cached = id != null ? searchMetadata[id] : null;

  bool isLoading = false;
  bool hasFailed = false;
  bool isEnrichedResult = false;

  if (cached != null) {
    if (cached is NoMetadataDTO) {
      hasFailed = true;
    } else if (cached is UnifiedMetadataDTO) {
      isEnrichedResult = true;
      imageUrl = cached.imageUrl ?? imageUrl;
      episodes = cached.episodes ?? episodes;
      // Only take the link if it belongs to the active provider (e.g. TVmaze)
      if (provider == MetadataProviderType.tvmaze && cached.linkUrl?.contains('tvmaze.com') == true) {
        linkUrl = cached.linkUrl;
      } else if (provider == MetadataProviderType.anilist && cached.linkUrl?.contains('anilist.co') == true) {
        linkUrl = cached.linkUrl;
      } else if (provider == MetadataProviderType.shikimori && (cached.linkUrl?.contains('shikimori.one') == true)) {
        linkUrl = cached.linkUrl;
      }
    }
  } else if (episodes == null && sourceKey == SearchSourceKeys.jimaku) {
    // If it's Jimaku and we have IDs but no cache, we are likely still loading enrichment
    if (anilistId != null || tmdbId != null || imdbId != null || thetvdbId != null) {
      isLoading = true;
    }
  }

  return EnrichedMetadata(
    title: title,
    subtitle: subtitle,
    imageUrl: imageUrl,
    episodes: episodes,
    linkUrl: linkUrl,
    isLoading: isLoading,
    hasFailed: hasFailed,
    isEnriched: isEnrichedResult,
  );
});
