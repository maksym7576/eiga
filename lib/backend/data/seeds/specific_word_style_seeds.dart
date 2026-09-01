import 'package:flutter/material.dart';
import 'package:eiga/backend/data/models/specific_word_style.dart';

Future<List<SpecificWordStyle>> standardWordStyles() async {
  return [
    SpecificWordStyle.create(
      name: 'know',
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
    SpecificWordStyle.create(
      name: "don't know",
      color: Colors.red,
      fontWeight: FontWeight.bold,
    ),
    SpecificWordStyle.create(
      name: 'doubt',
      color: Colors.orange,
      fontWeight: FontWeight.w500,
    ),
    SpecificWordStyle.create(
      name: 'standard',
      color: Colors.white,
      fontWeight: FontWeight.normal,
    ),
    SpecificWordStyle.create(
      name: 'learn',
      color: Colors.purple,
      fontWeight: FontWeight.bold,
    ),
  ];
}
