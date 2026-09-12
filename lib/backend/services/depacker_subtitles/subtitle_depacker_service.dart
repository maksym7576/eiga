import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import '../../database/schemas/phrase.dart';
import '../../database/schemas/video.dart';
import '../../database/services/phrase_service.dart';
import '../../database/services/video_service.dart';
import '../../database/services/language_service.dart';
import 'ass_parser_service.dart';
import 'srt_parser_service.dart';

class SubtitleDepackerService {
  final VideoService videoService;
  final PhraseService phraseService;
  final LanguageService languageService;

  SubtitleDepackerService({
    required this.videoService,
    required this.phraseService,
    required this.languageService,
  });

  Future<List<Phrase>> parseSrtPreview({
    required String filePath,
    required String language,
    int videoId = 0,
  }) async {
    String fileContent = await _readFile(filePath);

    if (fileContent.isEmpty) return [];

    final langConfig = await languageService.getLanguageByName(language);
    final removeAllSpaces = langConfig?.removeAllSpaces ?? false;

    return compute(_parseSubtitlesInIsolate, _SubtitleParseInput(
      content: fileContent,
      videoId: videoId,
      removeAllSpaces: removeAllSpaces,
      isAss: filePath.toLowerCase().endsWith('.ass'),
    ));
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

      final langConfig = await languageService.getLanguageByName(video.originalLanguage ?? '');
      final removeAllSpaces = langConfig?.removeAllSpaces ?? false;

      phrases = await compute(_parseSubtitlesInIsolate, _SubtitleParseInput(
        content: content,
        videoId: video.id,
        removeAllSpaces: removeAllSpaces,
        isAss: video.pathSubtitle!.toLowerCase().endsWith('.ass'),
      ));
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

