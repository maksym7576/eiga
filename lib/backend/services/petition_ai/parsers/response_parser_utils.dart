import 'dart:convert';

class ResponseParserUtils {
  static int parseId(dynamic raw) {
    if (raw is int) return raw;
    return int.tryParse(raw.toString()) ?? -1;
  }

  static List<int> parseIntList(dynamic raw) {
    if (raw is! List) return [];
    final result = <int>[];
    for (final item in raw) {
      if (item is int) {
        result.add(item);
      } else {
        final parsed = int.tryParse(item.toString());
        if (parsed != null) result.add(parsed);
      }
    }
    final uniqueSorted = result.toSet().toList()..sort();
    return uniqueSorted;
  }

  static String parseColorHex(dynamic raw) {
    final value = raw?.toString() ?? '';
    final isValidHex = RegExp(r'^#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})$').hasMatch(value);
    return isValidHex ? value : '#FFFFFF';
  }

  static Duration? parseRetryAfter(String body) {
    try {
      final Map<String, dynamic> data = jsonDecode(body);
      final message = data['error']?['message']?.toString() ?? '';
      
      // Google 429 often contains: "Please retry in 14.701831857s."
      final secMatch = RegExp(r'retry in (\d+\.?\d*)s').firstMatch(message);
      if (secMatch != null) {
        final seconds = double.tryParse(secMatch.group(1)!) ?? 0;
        return Duration(milliseconds: (seconds * 1000).toInt() + 1000); // +1s buffer
      }

      // Milliseconds: "retry in 219.830704ms"
      final msMatch = RegExp(r'retry in (\d+\.?\d*)ms').firstMatch(message);
      if (msMatch != null) {
        final ms = double.tryParse(msMatch.group(1)!) ?? 0;
        return Duration(milliseconds: ms.toInt() + 200);
      }
    } catch (_) {}
    return null;
  }
}
