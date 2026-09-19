import 'package:flutter/material.dart';

enum WordStatus {
  unknown,
  learning,
  known;

  String get displayName {
    switch (this) {
      case WordStatus.unknown: return 'Unknown';
      case WordStatus.learning: return 'Learning';
      case WordStatus.known: return 'Known';
    }
  }

  Color get color {
    switch (this) {
      case WordStatus.unknown: return const Color(0xFFF43F5E); // Rose
      case WordStatus.learning: return const Color(0xFF3B66F5); // Brand Blue
      case WordStatus.known: return const Color(0xFF10B981); // Emerald
    }
  }
}

class WordStatusUI {
  final WordStatus status;
  
  WordStatusUI(this.status);

  String get name => status.displayName;
  Color get color => status.color;
  FontWeight get fontWeight => FontWeight.w600;
}
