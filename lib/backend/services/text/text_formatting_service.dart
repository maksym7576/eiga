import '../../database/schemas/phrase.dart';

class TextFormattingService {
  // Класифікація для БД: 0 = none, 1 = merge (зліва), 2 = modify (справа)
  static AttachMode getAttachMode(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return AttachMode.none;
    
    // Кома, крапка, знак оклику, тощо -> приєднати до попереднього слова (merge)
    if (RegExp(r'^[\.,!\?\…—»\)\~\]\}]+$').hasMatch(trimmed)) {
      return AttachMode.merge;
    }
    // Лапки, відкриваючі дужки -> приєднати до наступного слова (modify)
    if (RegExp(r'^[«\(\[\{]+$').hasMatch(trimmed)) {
      return AttachMode.modify;
    }
    return AttachMode.none;
  }

  // Розрахунок відступів для UI
  static double getLeftPadding(TranslationTokenEntry token, double baseFontSize, bool globalNoSpacing) {
    if (globalNoSpacing) return 0.0;
    
    // Якщо в базі ще не проставлено, визначаємо режим на льоту на основі тексту
    final mode = (token.attachMode == AttachMode.none) 
        ? getAttachMode(token.text ?? '') 
        : token.attachMode;
        
    return (mode == AttachMode.merge) ? 0.0 : baseFontSize * 0.15;
  }

  static double getRightPadding(TranslationTokenEntry token, double baseFontSize, bool globalNoSpacing) {
    if (globalNoSpacing) return 0.0;
    
    // Якщо в базі ще не проставлено, визначаємо режим на льоту
    final mode = (token.attachMode == AttachMode.none) 
        ? getAttachMode(token.text ?? '') 
        : token.attachMode;

    return (mode == AttachMode.modify) ? 0.0 : baseFontSize * 0.3;
  }
}
