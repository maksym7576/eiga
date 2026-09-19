import 'app/en.dart';
import 'app/uk.dart';

class LocalizationHub {
  static const Map<String, Map<String, dynamic>> _appLabels = {
    'en': enAppLabels,
    'uk': ukAppLabels,
  };

  static Map<String, dynamic> getAppLabels(String langCode) {
    return _appLabels[langCode.toLowerCase()] ?? enAppLabels;
  }
}
