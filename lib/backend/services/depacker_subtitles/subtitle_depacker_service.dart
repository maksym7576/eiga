import 'dart:convert';
import 'dart:io';

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

    if (filePath.toLowerCase().endsWith('.ass')) {
      return AssParser(removeAllSpaces: removeAllSpaces).parse(fileContent, videoId);
    } else {
      return SrtParser(removeAllSpaces: removeAllSpaces).parse(fileContent, videoId);
    }
  }

  Future<void> depack(Video video) async {
    if (video.videoPath == null || video.pathSubtitle == null) return;

    final content = await _readFile(video.pathSubtitle!);

    final langConfig = await languageService.getLanguageByName(video.originalLanguage ?? '');
    final removeAllSpaces = langConfig?.removeAllSpaces ?? false;

    List<Phrase> phrases;
    if (video.pathSubtitle!.toLowerCase().endsWith('.ass')) {
      phrases = AssParser(removeAllSpaces: removeAllSpaces).parse(content, video.id);
    } else {
      phrases = SrtParser(removeAllSpaces: removeAllSpaces).parse(content, video.id);
    }

    await phraseService.addPhrasesList(phrases);
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
