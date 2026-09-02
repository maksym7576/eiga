import 'package:isar_community/isar.dart';
import '../schemas/language.dart';
import '../seeds/language_seeds.dart';

class LanguageService {
  final Isar db;

  LanguageService(this.db);

  Future<List<Language>> getAllLanguages() async {
    return await db.languages.where().findAll();
  }

  Future<Language?> getLanguageByName(String name) async {
    return await db.languages
        .filter()
        .nameEqualTo(name, caseSensitive: false)
        .findFirst();
  }

  Future<List<Language>> findLanguagesByName(String languageName) async {
    final lowerCase = languageName.toLowerCase();
    
    // First try database
    final dbResults = await db.languages
        .filter()
        .nameContains(languageName, caseSensitive: false)
        .findAll();
    
    if (dbResults.isNotEmpty) return dbResults;

    // Fallback to seeds if not in DB yet (e.g. before first run/seed)
    final languages = await standardLanguages();
    return languages
        .where(
          (language) =>
              (language.name ?? '').toLowerCase().contains(lowerCase),
        )
        .toList();
  }
}
