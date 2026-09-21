import '../../database/schemas/phrase.dart';

class SrtParser {
  final bool removeAllSpaces;

  SrtParser({this.removeAllSpaces = false});

  Map<String, List<Phrase>> parseMultiStream(String content, int videoId) {
    // For SRT, usually single stream, but we can check if lines contain dual language separated by newline or slash
    final phrases = parse(content, videoId);
    if (phrases.isEmpty) return {};
    return {'Default SRT': phrases};
  }

  List<Phrase> parse(String content, int videoId) {
    final phrases = <Phrase>[];
    int order = 1;

    final blocks = content
        .trim()
        .split(RegExp(r'\r?\n\s*\r?\n'))
        .map((b) => b.trim())
        .where((b) => b.isNotEmpty);

    for (final block in blocks) {
      final phrase = _parseBlock(block, videoId, order);
      if (phrase != null) {
        phrases.add(phrase);
        order++;
      }
    }

    return phrases;
  }

  Phrase? _parseBlock(String block, int videoId, int order) {
    if (block.contains('in][native]') || block.contains('~MyPlayer()')) return null;

    final lines = block
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (lines.isEmpty) return null;

    final timeLineIndex = int.tryParse(lines[0]) != null ? 1 : 0;
    if (lines.length <= timeLineIndex) return null;

    final times = lines[timeLineIndex].split(RegExp(r'\s*-->\s*'));
    if (times.length != 2) return null;

    final textLines = lines.sublist(timeLineIndex + 1);
    if (textLines.isEmpty) return null;

    return Phrase(
      videoId: videoId,
      phraseOrder: order,
      originalPhrase: _processText(textLines.join(' ')),
      startTime: _parseTime(times[0]),
      endTime: _parseTime(times[1]),
    );
  }

  String _processText(String text) {
    // 1. Strip ASS/SRT override tags like {\an8}, {\pos(...)}, etc.
    var cleanText = text.replaceAll(RegExp(r'\{[^}]*\}'), '');
    
    // 2. Strip HTML-like tags (even weird ones like <fontface=...>)
    // Using a more aggressive regex to catch tags with missing spaces
    cleanText = cleanText.replaceAll(RegExp(r'<[^>]*>'), '');
    
    // 3. Handle spaces based on language
    if (removeAllSpaces) {
      // Check if text actually contains CJK characters before removing ALL spaces
      // If it's mostly Latin, keep spaces for readability
      final latinMatch = RegExp(r'[a-zA-Z]').allMatches(cleanText).length;
      final totalChars = cleanText.replaceAll(RegExp(r'\s+'), '').length;
      
      if (totalChars > 0 && (latinMatch / totalChars) > 0.5) {
        // Mostly Latin text - keep spaces
        return cleanText.replaceAll(RegExp(r'\s+'), ' ').trim();
      }
      
      return cleanText.replaceAll(RegExp(r'\s+'), '');
    }
    
    return cleanText.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  DateTime _parseTime(String raw) {
    final m = RegExp(r'(\d{1,2}):(\d{2}):(\d{2})[,.](\d{1,3})').firstMatch(raw.trim());
    if (m == null) return DateTime(1970);

    var ms = m.group(4)!;
    if (ms.length == 1) {
      ms = '${ms}00';
    } else if (ms.length == 2) {
      ms = '${ms}0';
    }

    return DateTime(
      1970, 1, 1,
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
      int.parse(ms),
    );
  }
}
