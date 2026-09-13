import '../../database/schemas/phrase.dart';

class AssParser {
  final bool removeAllSpaces;

  static const _skipStyles = {'Title', 'Screen', 'AN7', 'Dial-CNI', 'STAFF', 'OP-JP', 'OP-CN'};

  AssParser({this.removeAllSpaces = false});

  /// Parses ASS content and groups phrases by individual style/stream (e.g. TEXT-JP, TEXT-CN)
  Map<String, List<Phrase>> parseMultiStream(String content, int videoId) {
    final Map<String, List<_DialogueGroup>> styleGroupsMap = {};

    final lines = content
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.startsWith('Dialogue:'))
        .toList();

    for (final line in lines) {
      final raw = _parseDialogueLine(line);
      if (raw == null || _skipStyles.contains(raw.style)) continue;

      styleGroupsMap.putIfAbsent(raw.style, () => []);
      final groups = styleGroupsMap[raw.style]!;

      if (groups.isNotEmpty &&
          groups.last.start == raw.start &&
          groups.last.end == raw.end) {
        groups.last.texts.add(raw.text);
      } else {
        groups.add(_DialogueGroup(raw.style, raw.start, raw.end, [raw.text]));
      }
    }

    final Map<String, List<Phrase>> result = {};
    for (final entry in styleGroupsMap.entries) {
      final style = entry.key;
      final groups = entry.value;
      final phrases = <Phrase>[];
      int order = 1;

      for (final group in groups) {
        final phrase = _toPhrase(group, videoId, order);
        if (phrase != null) {
          phrases.add(phrase);
          order++;
        }
      }

      if (phrases.isNotEmpty) {
        result[style] = phrases;
      }
    }

    return result;
  }

  List<Phrase> parse(String content, int videoId) {
    final multi = parseMultiStream(content, videoId);
    if (multi.isEmpty) return [];
    
    // Prefer styles with JP, TEXT, or default to the first available stream
    final preferredKey = multi.keys.firstWhere(
      (k) => k.toUpperCase().contains('JP') || k.toUpperCase().contains('TEXT'),
      orElse: () => multi.keys.first,
    );

    return multi[preferredKey] ?? multi.values.first;
  }

  _RawDialogue? _parseDialogueLine(String line) {
    final data = line.substring(9).trim();
    final parts = data.split(',');
    if (parts.length < 10) return null;

    final style = parts[3].trim();
    final startRaw = parts[1].trim();
    final endRaw = parts[2].trim();
    final rawText = parts.sublist(9).join(',');

    var cleanText = rawText.replaceAll(RegExp(r'\{[^}]*\}'), '');
    cleanText = cleanText.replaceAll(RegExp(r'\\[Nn]'), ' ').trim();
    if (cleanText.isEmpty) return null;

    return _RawDialogue(style, startRaw, endRaw, cleanText);
  }

  Phrase? _toPhrase(_DialogueGroup group, int videoId, int order) {
    final text = _processText(group.texts.join(' '));
    if (text.isEmpty) return null;

    return Phrase(
      videoId: videoId,
      phraseOrder: order,
      originalPhrase: text,
      startTime: _parseTime(group.start),
      endTime: _parseTime(group.end),
    );
  }

  String _processText(String text) {
    if (removeAllSpaces) return text.replaceAll(RegExp(r'\s+'), '');
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  DateTime _parseTime(String raw) {
    final m = RegExp(r'(\d+):(\d{2}):(\d{2})\.(\d+)').firstMatch(raw.trim());
    if (m == null) return DateTime(1970);

    var msStr = m.group(4)!;
    int ms;

    if (msStr.length == 2) {
      ms = int.parse(msStr) * 10;
    } else if (msStr.length == 1) {
      ms = int.parse(msStr) * 100;
    } else {
      ms = int.parse(msStr.substring(0, 3));
    }

    return DateTime(
      1970, 1, 1,
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
      ms,
    );
  }
}

class _RawDialogue {
  final String style;
  final String start;
  final String end;
  final String text;

  _RawDialogue(this.style, this.start, this.end, this.text);
}

class _DialogueGroup {
  final String style;
  final String start;
  final String end;
  final List<String> texts;

  _DialogueGroup(this.style, this.start, this.end, this.texts);
}
