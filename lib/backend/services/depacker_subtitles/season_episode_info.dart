class SeasonEpisodeInfo {
  final String? season;
  final String? episode;

  const SeasonEpisodeInfo({this.season, this.episode});
}

SeasonEpisodeInfo parseSeasonEpisode(String fileName) {
  // 1. S01E01 format
  final seMatch = RegExp(r'[Ss](\d{1,2})[Ee](\d{1,3})').firstMatch(fileName);
  if (seMatch != null) {
    return SeasonEpisodeInfo(
      season: seMatch.group(1),
      episode: seMatch.group(2),
    );
  }

  // 2. 'karteX' format (e.g. karte1, karte 01)
  final karteMatch = RegExp(r'karte\s*(\d{1,3})', caseSensitive: false).firstMatch(fileName);
  if (karteMatch != null) {
    return SeasonEpisodeInfo(episode: karteMatch.group(1));
  }

  // 3. Japanese format: 第X話 / 第X
  final jpEpMatch = RegExp(r'第\s*(\d{1,3})\s*[話화]').firstMatch(fileName);
  if (jpEpMatch != null) {
    return SeasonEpisodeInfo(episode: jpEpMatch.group(1));
  }

  // 4. 'Episode X' or 'Ep. X'
  final epWordMatch = RegExp(r'(?:episode|ep\.?)\s*(\d{1,3})', caseSensitive: false).firstMatch(fileName);
  if (epWordMatch != null) {
    return SeasonEpisodeInfo(episode: epWordMatch.group(1));
  }

  // 5. - E01 / E1
  final eOnlyMatch = RegExp(r'[-\s]E(\d{1,3})[-\s]').firstMatch(fileName);
  if (eOnlyMatch != null) {
    return SeasonEpisodeInfo(episode: eOnlyMatch.group(1));
  }

  // 6. - 01 [ or - 01 (
  final dashNumMatch = RegExp(r'-\s*(\d{1,3})\s*[\[\(]').firstMatch(fileName);
  if (dashNumMatch != null) {
    return SeasonEpisodeInfo(episode: dashNumMatch.group(1));
  }

  // 7. - 01 at word boundary
  final dashNumEndMatch = RegExp(r'-\s*(\d{1,3})\b').firstMatch(fileName);
  if (dashNumEndMatch != null) {
    return SeasonEpisodeInfo(episode: dashNumEndMatch.group(1));
  }

  // 8. General number search fallback (e.g. 01, 02 near extension or end)
  final generalMatch = RegExp(r'\b0*(\d{1,2})\b(?:\.\w+)?$').firstMatch(fileName);
  if (generalMatch != null) {
    final epNum = int.tryParse(generalMatch.group(1)!);
    if (epNum != null && epNum > 0 && epNum <= 100) {
      return SeasonEpisodeInfo(episode: epNum.toString());
    }
  }

  return const SeasonEpisodeInfo();
}
