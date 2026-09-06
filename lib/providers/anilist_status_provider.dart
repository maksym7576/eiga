import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

enum AniListStatus {
  online,
  maintenance,
  error,
}

final aniListStatusProvider = StateProvider<AniListStatus>((ref) => AniListStatus.online);
