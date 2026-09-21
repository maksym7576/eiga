import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';

class SubtitleMatcher {
  /// Finds the best matching subtitle file for a given episode number.
  /// 
  /// Uses regex patterns to identify episode numbers in filenames while avoiding
  /// common false positives like codecs (x264, x265) or resolutions.
  static FileJimakuDTO? findBestMatch({
    required List<FileJimakuDTO> files,
    required String targetEpisode,
    String? preferredExtension,
  }) {
    if (files.isEmpty) return null;

    final targetValue = targetEpisode.trim();
    final paddedValue = targetValue.padLeft(2, '0');

    // Patterns ordered by specificity (higher specificity matches first)
    final patterns = [
      // 1. Netflix/Amazon format: S01E02
      RegExp(r'[Ss]\d+[Ee]' + paddedValue + r'\b', caseSensitive: false),
      
      // 2. Specific markers: karte02, karte 02, Episode 02, Ep 02
      RegExp(r'karte\s*' + paddedValue + r'\b', caseSensitive: false),
      RegExp(r'karte\s*' + targetValue + r'\b', caseSensitive: false),
      RegExp(r'(?:episode|ep\.?)\s*' + paddedValue + r'\b', caseSensitive: false),
      RegExp(r'(?:episode|ep\.?)\s*' + targetValue + r'\b', caseSensitive: false),
      
      // 3. Japanese/Korean markers: 第02話
      RegExp(r'第\s*' + paddedValue + r'\s*[話화]', caseSensitive: false),
      RegExp(r'第\s*' + targetValue + r'\s*[話화]', caseSensitive: false),
      
      // 4. Bracketed numbers: [02], (02)
      RegExp(r'[\[(]' + paddedValue + r'[\])]', caseSensitive: false),
      RegExp(r'[\[(]' + targetValue + r'[\])]', caseSensitive: false),
      
      // 5. Delimited numbers: - 02 -, .02., _02_
      RegExp(r'[\s\-_.]+' + paddedValue + r'[\s\-_.]+', caseSensitive: false),
      
      // 6. Generic word boundaries: \b02\b, \b2\b
      RegExp(r'\b' + paddedValue + r'\b', caseSensitive: false),
      if (targetValue != paddedValue) RegExp(r'\b' + targetValue + r'\b', caseSensitive: false),
    ];

    // Filter matches
    final matches = files.where((f) {
      final name = f.name;
      return patterns.any((p) => p.hasMatch(name));
    }).toList();

    if (matches.isEmpty) return null;

    // Sorting heuristics:
    matches.sort((a, b) {
      // Priority 1: Preferred extension (e.g. .ass over .srt if requested)
      if (preferredExtension != null) {
        final aExt = a.name.toLowerCase().endsWith(preferredExtension.toLowerCase()) ? 1 : 0;
        final bExt = b.name.toLowerCase().endsWith(preferredExtension.toLowerCase()) ? 1 : 0;
        if (aExt != bExt) return bExt.compareTo(aExt);
      }
      
      // Priority 2: Pattern match score (how specific was the match)
      final aScore = _getMatchScore(a.name, patterns);
      final bScore = _getMatchScore(b.name, patterns);
      if (aScore != bScore) return bScore.compareTo(aScore);
      
      // Priority 3: Freshness
      final dateComp = b.lastModified.compareTo(a.lastModified);
      if (dateComp != 0) return dateComp;
      
      // Priority 4: Simplicity (shorter names are often better than long bloated ones)
      return a.name.length.compareTo(b.name.length);
    });

    return matches.first;
  }
  
  /// Assigns a score based on which pattern matched first (lower index = higher score)
  static int _getMatchScore(String name, List<RegExp> patterns) {
    for (int i = 0; i < patterns.length; i++) {
      if (patterns[i].hasMatch(name)) return patterns.length - i;
    }
    return 0;
  }

  /// Utility to extract all unique episode numbers from a list of files.
  static List<int> extractEpisodeNumbers(List<FileJimakuDTO> files) {
    final numbers = <int>{};
    
    // Patterns similar to those used in findBestMatch but for extraction
    final extractionPatterns = [
      RegExp(r'[Ss]\d+[Ee](\d{1,3})', caseSensitive: false),
      RegExp(r'karte\s*(\d{1,3})', caseSensitive: false),
      RegExp(r'第\s*(\d{1,3})\s*[話화]', caseSensitive: false),
      RegExp(r'(?:episode|ep\.?)\s*(\d{1,3})', caseSensitive: false),
      RegExp(r'[\[(](\d{1,3})[\])]', caseSensitive: false),
      RegExp(r'[\s\-_.]+(\d{1,3})[\s\-_.]+', caseSensitive: false),
      // Final fallback for trailing numbers or standalone numbers
      RegExp(r'\b0*(\d{1,3})\b', caseSensitive: false),
    ];
    
    for (final file in files) {
      for (final p in extractionPatterns) {
        final matches = p.allMatches(file.name);
        if (matches.isNotEmpty) {
          for (final m in matches) {
            final val = int.tryParse(m.group(1)!);
            // Blacklist common video-related numbers that are not episodes
            if (val != null && val > 0 && val < 2000 && 
                val != 480 && val != 720 && val != 1080 && val != 2160) {
              numbers.add(val);
            }
          }
          break; // Stop after first successful pattern match for this file
        }
      }
    }
    
    return numbers.toList()..sort();
  }
}
