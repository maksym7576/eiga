import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../backend/database/schemas/video.dart';
import '../../backend/database/schemas/job.dart';
import '../services/isar_services_providers.dart';

enum LibrarySortOrder { title, recent, language }

class LibrarySortOrderNotifier extends Notifier<LibrarySortOrder> {
  @override
  LibrarySortOrder build() => LibrarySortOrder.recent;
  set state(LibrarySortOrder value) => super.state = value;
}

final librarySortOrderProvider = NotifierProvider<LibrarySortOrderNotifier, LibrarySortOrder>(
  LibrarySortOrderNotifier.new,
);

class LibraryOriginalLangFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  set state(String? value) => super.state = value;
}

final libraryOriginalLangFilterProvider = NotifierProvider<LibraryOriginalLangFilterNotifier, String?>(
  LibraryOriginalLangFilterNotifier.new,
);

class LibraryTranslatedLangFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  set state(String? value) => super.state = value;
}

final libraryTranslatedLangFilterProvider = NotifierProvider<LibraryTranslatedLangFilterNotifier, String?>(
  LibraryTranslatedLangFilterNotifier.new,
);

final allVideosProvider = StreamProvider<List<Video>>((ref) {
  final service = ref.watch(videoServiceProvider);
  return service.watchAllVideos();
});

final filteredVideosProvider = Provider<AsyncValue<List<Video>>>((ref) {
  final videosAsync = ref.watch(allVideosProvider);
  final sortOrder = ref.watch(librarySortOrderProvider);
  final origFilter = ref.watch(libraryOriginalLangFilterProvider);
  final transFilter = ref.watch(libraryTranslatedLangFilterProvider);

  return videosAsync.whenData((videos) {
    var list = List<Video>.from(videos);

    if (origFilter != null && origFilter.isNotEmpty) {
      list = list.where((v) => v.originalLanguage?.toLowerCase() == origFilter.toLowerCase()).toList();
    }
    if (transFilter != null && transFilter.isNotEmpty) {
      list = list.where((v) => v.translatedLanguage?.toLowerCase() == transFilter.toLowerCase()).toList();
    }

    if (sortOrder == LibrarySortOrder.title) {
      list.sort((a, b) => (a.seriesName ?? a.fileName ?? '').compareTo(b.seriesName ?? b.fileName ?? ''));
    } else if (sortOrder == LibrarySortOrder.language) {
      list.sort((a, b) => (a.originalLanguage ?? '').compareTo(b.originalLanguage ?? ''));
    } else if (sortOrder == LibrarySortOrder.recent) {
      list.sort((a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
    }

    return list;
  });
});

final activeJobsProvider = StreamProvider<List<Job>>((ref) {
  final service = ref.watch(jobServiceProvider);
  return service.watchAllActiveJobs();
});
