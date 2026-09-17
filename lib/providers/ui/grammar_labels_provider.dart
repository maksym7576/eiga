import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';

class GrammarLabels {
  final Map<String, String> pos;
  final Map<String, String> grammarFunction;
  final Map<String, String> explanations;
  final Map<String, String> ui;

  GrammarLabels({
    this.pos = const {},
    this.grammarFunction = const {},
    this.explanations = const {},
    this.ui = const {},
  });

  factory GrammarLabels.fromJson(Map<String, dynamic> json) {
    return GrammarLabels(
      pos: Map<String, String>.from(json['pos'] ?? {}),
      grammarFunction: Map<String, String>.from(json['grammarFunction'] ?? {}),
      explanations: Map<String, String>.from(json['explanations'] ?? {}),
      ui: Map<String, String>.from(json['ui'] ?? {}),
    );
  }

  String getPosName(WordPos p) {
    final key = p.name;
    return pos[key] ?? pos['unknown'] ?? 'Unknown';
  }

  String getGfName(GrammarFunction gf) {
    final key = gf.name;
    return grammarFunction[key] ?? 'None';
  }

  String getExplanation(String key, {String? fallback}) {
    return explanations[key] ?? fallback ?? '';
  }

  String getUiLabel(String key, {String? fallback}) {
    return ui[key] ?? fallback ?? key.toUpperCase();
  }
}

class GrammarLabelsService {
  final GrammarLabels current;
  final GrammarLabels fallback;

  GrammarLabelsService({required this.current, required this.fallback});

  String getPosName(WordPos p) => current.getPosName(p);
  String getGfName(GrammarFunction gf) => current.getGfName(gf);
  
  String getExplanation(String key) {
    final res = current.getExplanation(key);
    if (res.isNotEmpty) return res;
    return fallback.getExplanation(key);
  }

  String getUiLabel(String key) {
    final res = current.getUiLabel(key);
    if (res != key.toUpperCase()) return res;
    return fallback.getUiLabel(key);
  }
}

final grammarLabelsProvider = FutureProvider<GrammarLabelsService>((ref) async {
  // Current app interface language. 
  // For now, we use 'en' as the solid primary.
  const String langCode = 'en'; 

  final String enJsonStr = await rootBundle.loadString('assets/grammar/labels_en.json');
  final GrammarLabels enLabels = GrammarLabels.fromJson(jsonDecode(enJsonStr));

  // If we ever add more UI languages, we would load 'labels_$langCode.json' here
  // and use enLabels as the fallback for missing keys.
  return GrammarLabelsService(current: enLabels, fallback: enLabels);
});
