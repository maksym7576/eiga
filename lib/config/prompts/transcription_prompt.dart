const String transcriptionPrompt = '''
Transcribe the provided audio.
Language: {LANGUAGE}.{CONTEXT_BLOCK}

Return a JSON array of objects with timestamps. 
Example format:
[
  {"start_ms": 1200, "end_ms": 3500, "text": "Hello world"},
  {"start_ms": 4000, "end_ms": 6000, "text": "Second phrase"}
]

Rules:
1. Precise timestamps in milliseconds.
2. Return ONLY the JSON array.
3. No preamble or markdown code blocks.
''';
