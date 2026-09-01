import 'package:eiga/backend/data/models/language.dart';

Future<List<Language>> standardLanguages() async {
  return [
    Language(
      name: 'Japanese',
      isSupported: true,
      removeAllSpaces: true,
      readingOptions: ['original', 'kana', 'romaji'],
      spacingOptions: ['romaji'],
    ),
    Language(
      name: 'English',
      isSupported: false,
      removeAllSpaces: false,
      readingOptions: ['original'],
      spacingOptions: ['original'],
    ),
    Language(
      name: 'Spanish',
      isSupported: false,
      removeAllSpaces: false,
      readingOptions: ['original'],
      spacingOptions: ['original'],
    ),
    Language(
      name: 'Ukrainian',
      isSupported: false,
      removeAllSpaces: false,
      readingOptions: ['original'],
      spacingOptions: ['original'],
    ),
    Language(
      name: 'Russian',
      isSupported: false,
      removeAllSpaces: false,
      readingOptions: ['original'],
      spacingOptions: ['original'],
    ),
    Language(
      name: 'German',
      isSupported: false,
      removeAllSpaces: false,
      readingOptions: ['original'],
      spacingOptions: ['original'],
    ),
    Language(
      name: 'French',
      isSupported: false,
      removeAllSpaces: false,
      readingOptions: ['original'],
      spacingOptions: ['original'],
    ),
    Language(
      name: 'Italian',
      isSupported: false,
      removeAllSpaces: false,
      readingOptions: ['original'],
      spacingOptions: ['original'],
    ),
    Language(
      name: 'Chinese',
      isSupported: false,
      removeAllSpaces: true,
      readingOptions: ['original'],
      spacingOptions: ['original'],
    ),
    Language(
      name: 'Korean',
      isSupported: false,
      removeAllSpaces: true,
      readingOptions: ['original'],
      spacingOptions: ['original'],
    ),
  ];
}
