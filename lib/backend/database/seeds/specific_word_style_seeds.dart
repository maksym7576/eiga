import 'package:flutter/material.dart';
import '../schemas/specific_word_style.dart';

List<SpecificWordStyle> standardWordStyles() {
  return [
    SpecificWordStyle.create(
      name: 'Known',
      color: const Color(0xFF10B981), // Emerald
      fontWeight: FontWeight.w600,
    ),
    SpecificWordStyle.create(
      name: 'Learning',
      color: const Color(0xFF3B66F5), // Brand Blue
      fontWeight: FontWeight.w600,
    ),
    SpecificWordStyle.create(
      name: 'Unknown',
      color: const Color(0xFFF43F5E), // Rose
      fontWeight: FontWeight.w600,
    ),
  ];
}
