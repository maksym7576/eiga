import 'package:eiga/backend/database/schemas/phrase.dart';

class SubtitleTimingReport {
  final int outOfBoundsCount;
  final int overDurationCount;
  final List<String> warningMessages;

  SubtitleTimingReport({
    required this.outOfBoundsCount,
    required this.overDurationCount,
    required this.warningMessages,
  });
}

class SubtitleTimingValidator {
  static SubtitleTimingReport analyze(List<Phrase> phrases, int blockStartSec, int blockEndSec) {
    int outOfBounds = 0;
    int overDuration = 0;
    final List<String> warnings = [];

    final baseDate = DateTime(1970, 1, 1);

    for (var p in phrases) {
      if (p.startTime == null || p.endTime == null) continue;
      final startSec = p.startTime!.difference(baseDate).inSeconds;
      final endSec = p.endTime!.difference(baseDate).inSeconds;
      final duration = endSec - startSec;

      // Check if phrase falls outside block bounds
      if (endSec < blockStartSec || startSec > blockEndSec) {
        outOfBounds++;
        warnings.add('Phrase "${p.originalPhrase}" (${_fmt(startSec)}-${_fmt(endSec)}) is outside block bounds (${_fmt(blockStartSec)}-${_fmt(blockEndSec)})');
      }

      // Check if a single phrase is excessively long (e.g. > 10s, equivalent to 2-3 phrases)
      if (duration > 10) {
        overDuration++;
        warnings.add('Long phrase duration (${duration}s): "${p.originalPhrase}"');
      }
    }

    return SubtitleTimingReport(
      outOfBoundsCount: outOfBounds,
      overDurationCount: overDuration,
      warningMessages: warnings,
    );
  }

  static String _fmt(int s) {
    int m = s ~/ 60;
    int sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
