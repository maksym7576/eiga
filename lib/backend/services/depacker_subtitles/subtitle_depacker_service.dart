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

    if (isAss) {
      return compute(_parseAssMultiStreamInIsolate, _SubtitleParseInput(
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
      return {'Default SRT': phrases};
    }
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

