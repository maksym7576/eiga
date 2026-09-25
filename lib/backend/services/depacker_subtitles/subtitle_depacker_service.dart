import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:eiga/config/languages/language_hub.dart';
import '../../database/schemas/phrase.dart';
import '../../database/schemas/video.dart';
import '../database/phrase_service.dart';
import '../database/video_service.dart';
import 'ass_parser_service.dart';
import 'srt_parser_service.dart';

class SubtitleDepackerService {
  final VideoService videoService;
  final PhraseService phraseService;

  SubtitleDepackerService({
    required this.videoService,
    required this.phraseService,
  });

  Future<List<Phrase>> parseSrtPreview({
    required String filePath,
    required String language,
    int videoId = 0,
  }) async {
    final streams = await parseMultiStreamPreview(filePath: filePath, language: language, videoId: videoId);
    if (streams.isEmpty) return [];
    return streams.values.first;
  }

  Future<Map<String, List<Phrase>>> parseMultiStreamPreview({
    required String filePath,
    required String language,
    int videoId = 0,
  }) async {
    String fileContent = await _readFile(filePath);
    if (fileContent.isEmpty) return {};

    final langConfig = LanguageHub.getByName(language);
    final removeAllSpaces = langConfig?.removeAllSpaces ?? false;
    final isAss = filePath.toLowerCase().endsWith('.ass');

    Map<String, List<Phrase>> rawStreams;

    if (isAss) {
      rawStreams = await compute(_parseAssMultiStreamInIsolate, _SubtitleParseInput(
        content: fileContent,
        videoId: videoId,
        removeAllSpaces: removeAllSpaces,
        isAss: true,
      ));
    } else {
      final phrases = await compute(_parseSrtInIsolate, _SubtitleParseInput(
        content: fileContent,
        videoId: videoId,
        removeAllSpaces: removeAllSpaces,
        isAss: false,
      ));
      rawStreams = {'Default SRT': phrases};
    }

    // Застосовуємо алгоритм розумного мержингу та очищення до кожного потоку субтитрів
    final Map<String, List<Phrase>> mergedStreams = {};
    rawStreams.forEach((streamName, phrasesList) {
      mergedStreams[streamName] = mergePhraseCues(phrasesList);
    });

    return mergedStreams;
  }

  static Map<String, List<Phrase>> _parseAssMultiStreamInIsolate(_SubtitleParseInput input) {
    return AssParser(removeAllSpaces: input.removeAllSpaces).parseMultiStream(input.content, input.videoId);
  }

  static List<Phrase> _parseSrtInIsolate(_SubtitleParseInput input) {
    return SrtParser(removeAllSpaces: input.removeAllSpaces).parse(input.content, input.videoId);
  }

  Future<void> depack(Video video, {List<Phrase>? preParsedPhrases}) async {
    if (video.videoPath == null) return;

    List<Phrase> phrases;

    if (preParsedPhrases != null && preParsedPhrases.isNotEmpty) {
      phrases = preParsedPhrases.map((p) {
        p.videoId = video.id;
        return p;
      }).toList();
    } else {
      if (video.pathSubtitle == null) return;
      final content = await _readFile(video.pathSubtitle!);

      final langConfig = LanguageHub.getByName(video.originalLanguage ?? '');
      final removeAllSpaces = langConfig?.removeAllSpaces ?? false;

      final parsedRaw = await compute(_parseSubtitlesInIsolate, _SubtitleParseInput(
        content: content,
        videoId: video.id,
        removeAllSpaces: removeAllSpaces,
        isAss: video.pathSubtitle!.toLowerCase().endsWith('.ass'),
      ));
      
      // Застосовуємо мержинг при імпорті в базу даних
      phrases = mergePhraseCues(parsedRaw);
    }

    await phraseService.addPhrasesList(phrases);
  }

  static List<Phrase> _parseSubtitlesInIsolate(_SubtitleParseInput input) {
    if (input.isAss) {
      return AssParser(removeAllSpaces: input.removeAllSpaces).parse(input.content, input.videoId);
    } else {
      return SrtParser(removeAllSpaces: input.removeAllSpaces).parse(input.content, input.videoId);
    }
  }

  Future<String> _readFile(String path) async {
    final file = File(path);
    if (!file.existsSync()) return '';
    try {
      return await file.readAsString(encoding: utf8);
    } catch (_) {
      try {
        return await file.readAsString(encoding: Encoding.getByName('shift-jis') ?? latin1);
      } catch (e) {
        return '';
      }
    }
  }

  /// Допоміжні методи для розумного очищення та мержингу фраз
  static final RegExp _bracketNoise = RegExp(r'[([\{（［｛].*?[)\]\}）］｝]', dotAll: true);

  static String _normalize(String raw) {
    return raw
        .replaceAll(_bracketNoise, '')
        .replaceAll(RegExp(r'\\N', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'[\r\n]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static List<Phrase> mergePhraseCues(List<Phrase> phrases) {
    if (phrases.isEmpty) return [];

    final List<Phrase> result = [];

    Phrase cur = phrases.first;
    String curClean = _normalize(cur.originalPhrase ?? '');

    void flush() {
      if (curClean.isNotEmpty) {
        result.add(Phrase(
          videoId: cur.videoId,
          phraseOrder: result.length + 1,
          originalPhrase: curClean,
          translatedPhrase: cur.translatedPhrase,
          startTime: cur.startTime,
          endTime: cur.endTime,
          isActive: cur.isActive,
          originalTokens: cur.originalTokens,
          translatedWords: cur.translatedWords,
          linkGroups: cur.linkGroups,
          idiomSpans: cur.idiomSpans,
          stageStatuses: cur.stageStatuses,
        ));
      }
    }

    for (int i = 1; i < phrases.length; i++) {
      final next = phrases[i];
      final clean = _normalize(next.originalPhrase ?? '');

      if (cur.endTime == null || next.startTime == null) {
        flush();
        cur = next;
        curClean = clean;
        continue;
      }

      final bool isDuplicate = clean == curClean;
      final bool isExtension = clean.isNotEmpty && curClean.isNotEmpty &&
          (clean.startsWith(curClean) || curClean.startsWith(clean));

      final bool isAdjacent = (next.startTime!.difference(cur.endTime!)).inMilliseconds.abs() <= 400;

      if (isAdjacent && (isDuplicate || isExtension)) {
        if (next.endTime != null && (cur.endTime == null || next.endTime!.isAfter(cur.endTime!))) {
          cur.endTime = next.endTime;
        }
        if (next.startTime != null && (cur.startTime == null || next.startTime!.isBefore(cur.startTime!))) {
          cur.startTime = next.startTime;
        }
        if (clean.length > curClean.length) curClean = clean;
      } else {
        flush();
        cur = next;
        curClean = clean;
      }
    }
    flush();

    // Сортуємо фінальний результат за часом, щоб уникнути багів з "стрибаючими" таймінгами
    result.sort((a, b) {
      if (a.startTime == null || b.startTime == null) return 0;
      return a.startTime!.compareTo(b.startTime!);
    });

    return result;
  }
}

class _SubtitleParseInput {
  final String content;
  final int videoId;
  final bool removeAllSpaces;
  final bool isAss;

  _SubtitleParseInput({
    required this.content,
    required this.videoId,
    required this.removeAllSpaces,
    required this.isAss,
  });
}
