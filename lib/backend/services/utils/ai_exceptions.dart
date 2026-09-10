enum AiErrorType { auth, rateLimit, server, parse, unknown }

class AiUserFacingError {
  final String title;
  final String message;
  final String instruction;

  const AiUserFacingError({
    required this.title,
    required this.message,
    required this.instruction,
  });
}

extension AiErrorTypeUiMapper on AiErrorType {
  AiUserFacingError toUserFacing() {
    switch (this) {
      case AiErrorType.auth:
        return const AiUserFacingError(
          title: 'Проблема з токеном',
          message: 'API-ключ невірний, протермінований або запит сформований неправильно.',
          instruction: 'Відкрий налаштування і встав дійсний ключ з Google AI Studio.',
        );
      case AiErrorType.rateLimit:
        return const AiUserFacingError(
          title: 'Перевищено ліміт запитів',
          message: 'Забагато запитів або вичерпана квота для обраної моделі.',
          instruction: 'Зачекай кілька хвилин або зміни модель у налаштуваннях.',
        );
      case AiErrorType.server:
        return const AiUserFacingError(
          title: 'Сервер Gemini недоступний',
          message: 'Тимчасова проблема на боці Google.',
          instruction: 'Спробуй повторити запит через хвилину-дві.',
        );
      case AiErrorType.parse:
        return const AiUserFacingError(
          title: 'Помилка обробки відповіді',
          message: 'AI повернув дані у невірному форматі.',
          instruction: 'Спробуйте повторити запит для цих фраз.',
        );
      default:
        return const AiUserFacingError(
          title: 'Невідома помилка',
          message: 'Сталося щось непередбачене під час запиту.',
          instruction: 'Спробуйте ще раз. Якщо повторюється — перезапустіть застосунок.',
        );
    }
  }
}

class PartialFailureInfo {
  final List<String> failedPhraseIds;
  const PartialFailureInfo(this.failedPhraseIds);

  AiUserFacingError toUserFacing() => AiUserFacingError(
    title: 'Не всі фрази оброблено',
    message: 'Не вдалося обробити ${failedPhraseIds.length} фраз(и) з відповіді.',
    instruction: 'Можете повторити запит пізніше лише для цих фраз.',
  );
}

abstract class GeminiException implements Exception {
  final String message;
  final Duration? retryAfter;
  
  GeminiException(this.message, {this.retryAfter});

  AiErrorType get type;

  @override
  String toString() => message;
}

class GeminiModelExpiredException extends GeminiException {
  GeminiModelExpiredException(String message, {Duration? retryAfter}) 
      : super(message, retryAfter: retryAfter);
  @override
  AiErrorType get type => AiErrorType.rateLimit;
}

class GeminiIncorrectTokenException extends GeminiException {
  GeminiIncorrectTokenException(String message) : super(message);
  @override
  AiErrorType get type => AiErrorType.auth;
}

class GeminiGeneralException extends GeminiException {
  GeminiGeneralException(String message, {Duration? retryAfter}) 
      : super(message, retryAfter: retryAfter);
  @override
  AiErrorType get type => AiErrorType.unknown;
}

class GeminiServerException extends GeminiException {
  GeminiServerException(String message, {Duration? retryAfter}) 
      : super(message, retryAfter: retryAfter);
  @override
  AiErrorType get type => AiErrorType.server;
}
