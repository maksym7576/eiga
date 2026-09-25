import 'package:isar_community/isar.dart';
import '../../services/petition_ai/parsers/text_pipeline.dart';

part 'phrase.g.dart';

class PhraseUiStatus {
  final String? activeStageKey; // null = all steps completed
  final StageState state;

  bool get isProcessing => state == StageState.processing;
  bool get isError => state == StageState.error;
  bool get isDone => activeStageKey == null && state == StageState.completed;

  const PhraseUiStatus(this.activeStageKey, this.state);
}

@collection
class Phrase {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('phraseOrder')], type: IndexType.value)
  int? videoId;

  int? phraseOrder;

  @Index(type: IndexType.value)
  String? originalPhrase;

  @Index(type: IndexType.value)
  String? translatedPhrase;

  @Index()
  DateTime? startTime;

  @Index()
  DateTime? endTime;

  bool isActive = false;

  bool isSynced = false;
  DateTime? lastSyncedAt;

  // Раніше окремі колекції Word / TranslationWord / Block —
  // тепер повністю embedded, приходять разом із Phrase в одному запиті.
  List<TokenEntry>? originalTokens;
  List<TranslationTokenEntry>? translatedWords;
  List<LinkGroup>? linkGroups;
  
  @ignore
  List<List<int>>? idiomSpans;

  List<String> get idiomSpansIsar {
    return idiomSpans?.map((span) => span.join(',')).toList() ?? [];
  }

  set idiomSpansIsar(List<String> values) {
    idiomSpans = values
        .map((s) => s.split(',').map((e) => int.tryParse(e)).whereType<int>().toList())
        .toList();
  }

  List<String> stageKeys = [];
  List<String> stageValues = [];

  Phrase({
    this.videoId,
    this.phraseOrder,
    this.originalPhrase,
    this.translatedPhrase,
    this.startTime,
    this.endTime,
    this.isActive = false,
    this.originalTokens,
    this.translatedWords,
    this.linkGroups,
    this.idiomSpans,
    Map<String, String>? stageStatuses,
  }) {
    if (stageStatuses != null) {
      stageKeys = stageStatuses.keys.toList();
      stageValues = stageStatuses.values.toList();
    }
  }

  @ignore
  Map<String, String> get stageStatuses {
    final map = <String, String>{};
    for (int i = 0; i < stageKeys.length && i < stageValues.length; i++) {
      map[stageKeys[i]] = stageValues[i];
    }
    return map;
  }

  set stageStatuses(Map<String, String> statuses) {
    stageKeys = statuses.keys.toList();
    stageValues = statuses.values.toList();
  }

  @ignore
  PhraseUiStatus get uiStatus {
    final Map<String, String> statuses = stageStatuses;
    final bool hasTranslation = translatedPhrase != null && translatedPhrase!.isNotEmpty;

    for (final key in StageKey.order) {
      String raw = statuses[key] ?? 'pending';
      
      // AUTO-SKIP: If we have a translation but the stage is still pending, 
      // treat it as completed for context and translation stages.
      if (raw == 'pending' && hasTranslation && (key == StageKey.context || key == StageKey.translation)) {
        raw = 'completed';
      }

      final state = StageState.values.asNameMap()[raw] ?? StageState.pending;

      if (state != StageState.completed) {
        return PhraseUiStatus(key, state);
      }
    }
    return const PhraseUiStatus(null, StageState.completed);
  }

  @ignore
  bool get isTranslated => uiStatus.isDone;

  @ignore
  bool get isTranslating => uiStatus.isProcessing;

  @ignore
  String get activeStageName {
    final key = uiStatus.activeStageKey;
    if (key == null) return '';
    switch (key) {
      case StageKey.context: return 'Researching context';
      case StageKey.translation: return 'Translating';
      case StageKey.tokenizeSource: return 'Analyzing source';
      case StageKey.tokenizeTranslation: return 'Analyzing translation';
      case StageKey.morphology: return 'Building links';
      case StageKey.grammarRole: return 'Building sentence diagram';
      default: return 'Processing';
    }
  }
}

enum WordPos { v, i, d, n, p, x, s, o, unknown }

enum GrammarFunction {
  subj, obj, obj2, top, ctr, poss, mod, apos,
  loc, dir, src, tgt, tim, mns, rsn, prp, cnd, cnc, cmp, lim, deg,
  quo, cnj, emp, q, itj, pred, dep, oth, none
}

enum GroupRole { head, particle, auxiliary, suffix, prefix, inflection, punct }

enum AttachMode { merge, modify, none }

enum Tense { none, nonPast, past }

enum Aspect { none, progressive, resultative, perfective, preparatory, attempt, inceptive, continuative, iterative, benefactive }

enum Polarity { affirmative, negative }

enum Politeness { plain, polite, humble, honorific }

enum Modality { none, hearsay, appearance, conjecture, likelihood, certainty, obligation, permission, prohibition, desire, volition, ability, passive, causative, causativePassive, conditional }

@embedded
class LinkGroup {
  int? groupId;
  List<int> sourcePositions = [];
  List<int> targetPositions = [];
  int? headSourcePosition;
  List<int> relatedGroupIds = [];
  bool isIdiom = false;

  LinkGroup({
    this.groupId,
    this.sourcePositions = const [],
    this.targetPositions = const [],
    this.headSourcePosition,
    this.relatedGroupIds = const [],
    this.isIdiom = false,
  });
}

// Слово оригіналу (колишня колекція Word) — тепер embedded у Phrase.originalTokens
@embedded
class TokenEntry {
  int? wordPosition;
  
  @enumerated
  WordPos pos = WordPos.unknown;
  
  @enumerated
  GrammarFunction grammarFunction = GrammarFunction.none;

  @enumerated
  GroupRole groupRole = GroupRole.head;

  @enumerated
  AttachMode attachMode = AttachMode.none;

  int? headPosition;
  int? linkGroupId;
  String? lemma;
  String? surface;
  String? grammarCode;
  String? relationLabel;

  @enumerated
  Tense tense = Tense.none;

  @enumerated
  Aspect aspect = Aspect.none;

  @enumerated
  Polarity polarity = Polarity.affirmative;

  @enumerated
  Politeness politeness = Politeness.plain;

  @enumerated
  Modality modality = Modality.none;

  int? blockId; // групування в межах ЦІЄЇ фрази, не глобальний FK

  List<ReadingItem> versions = [];

  bool isClickable = true;

  @ignore
  int get id => wordPosition ?? 0;

  @ignore
  String get mainText => TextPipeline.clean(
    versions.firstWhere(
      (v) => v.key == 'original',
      orElse: () => versions.isNotEmpty ? versions.first : ReadingItem(),
    ).text,
    field: TextField.originalToken,
  );

  TokenEntry({
    this.wordPosition,
    this.pos = WordPos.unknown,
    this.grammarFunction = GrammarFunction.none,
    this.groupRole = GroupRole.head,
    this.attachMode = AttachMode.none,
    this.headPosition,
    this.linkGroupId,
    this.lemma,
    this.surface,
    this.grammarCode,
    this.relationLabel,
    this.tense = Tense.none,
    this.aspect = Aspect.none,
    this.polarity = Polarity.affirmative,
    this.politeness = Politeness.plain,
    this.modality = Modality.none,
    this.blockId,
    this.versions = const [],
    this.isClickable = true,
  });
}

// Слово перекладу (колишня колекція TranslationWord) — тепер embedded у Phrase.translatedWords
@embedded
class TranslationTokenEntry {
  int? blockId; // групування в межах ЦІЄЇ фрази, не глобальний FK
  int? translatedWordPosition;
  String? text;
  bool isInferred = false;
  List<int> sourceWordPositions = [];
  int? linkGroupId;

  @enumerated
  AttachMode attachMode = AttachMode.none;

  @ignore
  int get id => translatedWordPosition ?? 0;

  TranslationTokenEntry({
    this.blockId,
    this.translatedWordPosition,
    this.text,
    this.isInferred = false,
    this.sourceWordPositions = const [],
    this.linkGroupId,
    this.attachMode = AttachMode.none,
  });
}

@embedded
class ReadingItem {
  String? key;
  String? text;

  ReadingItem({this.key, this.text});
}

class StageKey {
  static const context = 'context';
  static const translation = 'translation';
  static const tokenizeSource = 'tokenize_source';
  static const tokenizeTranslation = 'tokenize_translation';
  static const morphology = 'morphology';
  static const grammarRole = 'grammar_role';

  static const List<String> order = [
    context,
    translation,
    tokenizeSource,
    tokenizeTranslation,
    morphology,
    grammarRole,
  ];
}

enum StageState {
  pending,
  processing,
  completed,
  error;

  String get displayName {
    switch (this) {
      case StageState.pending:
        return 'Pending';
      case StageState.processing:
        return 'Processing';
      case StageState.completed:
        return 'Completed';
      case StageState.error:
        return 'Error';
    }
  }
}
