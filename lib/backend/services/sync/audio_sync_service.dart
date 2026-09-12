import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:ffmpeg_kit_flutter_new_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_audio/return_code.dart';
import 'package:fftea/fftea.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vad/vad.dart';
import '../../database/schemas/phrase.dart';

enum SyncMatchResultType { perfect, offset, mismatch, error }

class SyncCheckpoint {
  final String index;
  final String timeRange;
  final String phraseText;
  final String offsetText;
  final String statusText;
  final String explanationText;
  final bool isDeviation;

  SyncCheckpoint({
    required this.index,
    required this.timeRange,
    required this.phraseText,
    required this.offsetText,
    required this.statusText,
    required this.explanationText,
    required this.isDeviation,
  });
}

class SyncResult {
  final SyncMatchResultType type;
  final Duration? offset;
  final double confidence;
  final String? message;
  final String? explanation;
  final List<SyncCheckpoint> checkpoints;
  
  // Technical Metrics
  final double pnr;
  final double uniqueness;
  final int consensusCount;

  SyncResult({
    required this.type,
    this.offset,
    this.confidence = 0.0,
    this.message,
    this.explanation,
    this.checkpoints = const [],
    this.pnr = 0.0,
    this.uniqueness = 0.0,
    this.consensusCount = 0,
  });
}

class _SyncSegment {
  final int startS;
  final int durationS;
  _SyncSegment(this.startS, this.durationS);
}

class _CorrelationInput {
  final List<double> audioSignal;
  final List<double> subSignal;
  final int windowSizeMs;

  _CorrelationInput({
    required this.audioSignal,
    required this.subSignal,
    required this.windowSizeMs,
  });
}

class _SubtitleActivityInput {
  final List<Phrase> phrases;
  final int length;
  final int segmentStartS;
  final int windowSizeMs;

  _SubtitleActivityInput({
    required this.phrases,
    required this.length,
    required this.segmentStartS,
    required this.windowSizeMs,
  });
}

class AudioSyncService {
  static const int sampleRate = 16000;
  static const int frameSamples = 512; // Silero VAD v5 requirement
  static const int windowSizeMs = (frameSamples * 1000) ~/ sampleRate; // ~32ms

  final Map<int, List<double>> _cachedAudioSignals = {};
  String? _lastVideoPath;
  
  VadIterator? _persistentVad;

  Future<void> _ensureVadInitialized() async {
    if (_persistentVad != null) return;
    
    try {
      // Force initialization of the binary messenger if needed
      try {
        BackgroundIsolateBinaryMessenger.ensureInitialized(RootIsolateToken.instance!);
      } catch (_) {}

      await Future.delayed(const Duration(milliseconds: 250));
      
      _persistentVad = await VadIterator.create(
        isDebug: false,
        sampleRate: sampleRate,
        frameSamples: frameSamples,
        positiveSpeechThreshold: 0.5,
        negativeSpeechThreshold: 0.35,
        redemptionFrames: 1,
        preSpeechPadFrames: 1,
        minSpeechFrames: 1,
        model: 'v5',
        baseAssetPath: 'assets/models/',
      );
      developer.log('Persistent VAD initialized successfully.', name: 'AudioSync');
    } catch (e, st) {
      developer.log('VAD Initialization Failed', name: 'AudioSync', error: e, stackTrace: st);
      rethrow;
    }
  }

  void clearCache() {
    _cachedAudioSignals.clear();
    _lastVideoPath = null;
    _persistentVad?.release();
    _persistentVad = null;
    developer.log('Sync cache cleared', name: 'AudioSync');
  }

  Future<SyncResult> analyzeSync({
    required String videoPath,
    required List<Phrase> phrases,
    VadIterator? externalVad,
    int? durationS,
    int? skipMinutes,
    int? pointDurationMinutes,
  }) async {
    developer.log('Starting neural multi-segment analysis...', name: 'AudioSync');

    if (_lastVideoPath != videoPath) {
      clearCache();
      _lastVideoPath = videoPath;
    }

    if (phrases.length < 5) {
      return SyncResult(type: SyncMatchResultType.error, message: 'Too few phrases', checkpoints: []);
    }

    // Determine segments dynamically
    int effectiveDuration = durationS ?? 0;
    if (effectiveDuration <= 0) {
      effectiveDuration = await _getVideoDuration(videoPath);
    }

    final segments = _generateDynamicSegments(
      effectiveDuration,
      skipMinutes: skipMinutes,
      pointDurationMinutes: pointDurationMinutes,
    );
    developer.log('Analyzing $videoPath with ${segments.length} segments (Total duration: ${effectiveDuration}s)', name: 'AudioSync');

    VadIterator? vadIterator = externalVad;
    final List<_CorrelationResult> results = [];
    final List<SyncCheckpoint> checkpoints = [];

    try {
      if (vadIterator == null) {
        await _ensureVadInitialized();
        vadIterator = _persistentVad;
      }
      
      if (vadIterator == null) throw Exception('VAD engine failed to initialize');

      for (int i = 0; i < segments.length; i++) {
        final seg = segments[i];
        List<double>? audioSignal = _cachedAudioSignals[seg.startS];
        
        if (audioSignal == null) {
          developer.log('Processing segment ${i + 1} (${seg.startS}s)...', name: 'AudioSync');
          audioSignal = await _extractAndGenerateVoiceMap(videoPath, seg, vadIterator);
          if (audioSignal != null) {
            _cachedAudioSignals[seg.startS] = audioSignal;
          }
        }

        if (audioSignal != null && audioSignal.isNotEmpty) {
          final subSignal = await compute(_generateSubtitleActivityMapInIsolate, _SubtitleActivityInput(
            phrases: phrases,
            length: audioSignal.length,
            segmentStartS: seg.startS,
            windowSizeMs: windowSizeMs,
          ));
          
          final correlation = await compute(_findBestOffsetInIsolate, _CorrelationInput(
            audioSignal: audioSignal,
            subSignal: subSignal,
            windowSizeMs: windowSizeMs,
          ));
          
          if (correlation.confidence > 0.1) {
            results.add(correlation);
            developer.log('Segment ${i+1} result: ${correlation.offsetWindows * windowSizeMs}ms (Conf: ${correlation.confidence.toStringAsFixed(2)})', name: 'AudioSync');
            
            // Create checkpoint
            final offsetMs = correlation.offsetWindows * windowSizeMs;
            final isDeviation = correlation.confidence < 0.3 || offsetMs.abs() > 1000;
            
            // Find a phrase in this segment for display
            final representativePhrase = _findRepresentativePhrase(phrases, seg.startS, seg.durationS);
            
            checkpoints.add(SyncCheckpoint(
              index: '#${i + 1}',
              timeRange: _formatTimeRange(seg.startS, seg.durationS),
              phraseText: representativePhrase != null ? '“${representativePhrase.originalPhrase}”' : 'Silence / No subtitles',
              offsetText: '${offsetMs >= 0 ? '+' : ''}${(offsetMs / 1000.0).toStringAsFixed(2)}s',
              statusText: isDeviation ? 'deviation' : 'aligned',
              explanationText: correlation.confidence > 0.6 
                  ? 'Matched via audio correlation with high confidence.' 
                  : (correlation.confidence > 0.3 
                      ? 'Aligned successfully with slight local variations.'
                      : 'Potential deviation detected due to weak signal or noise.'),
              isDeviation: isDeviation,
            ));
          }
        }
      }

      if (results.isEmpty) {
        return SyncResult(
          type: SyncMatchResultType.mismatch, 
          confidence: 0.0,
          explanation: 'No voice activity matched these subtitles.',
          checkpoints: checkpoints,
        );
      }

      final consolidated = _consolidateResults(results);
      return SyncResult(
        type: consolidated.type,
        offset: consolidated.offset,
        confidence: consolidated.confidence,
        explanation: consolidated.explanation,
        pnr: consolidated.pnr,
        uniqueness: consolidated.uniqueness,
        consensusCount: consolidated.consensusCount,
        checkpoints: checkpoints,
      );

    } catch (e, st) {
      developer.log('Critical sync error', name: 'AudioSync', error: e, stackTrace: st);
      return SyncResult(type: SyncMatchResultType.error, message: 'Neural Sync Error: $e', checkpoints: []);
    } finally {
      // Do not release persistent VAD here
    }
  }

  /// Pre-generates voice maps for a video to speed up batch processing.
  Future<void> preheatVoiceMaps(String videoPath, {int? durationS}) async {
    if (_lastVideoPath == videoPath && _cachedAudioSignals.isNotEmpty) return;
    
    clearCache();
    _lastVideoPath = videoPath;

    int effectiveDuration = durationS ?? 0;
    if (effectiveDuration <= 0) {
      effectiveDuration = await _getVideoDuration(videoPath);
    }

    final segments = _generateDynamicSegments(effectiveDuration);
    developer.log('Pre-heating ${segments.length} segments for video ($effectiveDuration s)', name: 'AudioSync');

    try {
      await _ensureVadInitialized();
      final vadIterator = _persistentVad;
      if (vadIterator == null) return;

      for (var seg in segments) {
        developer.log('Pre-heating segment at ${seg.startS}s', name: 'AudioSync');
        final signal = await _extractAndGenerateVoiceMap(videoPath, seg, vadIterator);
        if (signal != null) {
          _cachedAudioSignals[seg.startS] = signal;
        }
      }
    } catch (e, st) {
      developer.log('Pre-heat failed', name: 'AudioSync', error: e, stackTrace: st);
    }
  }

  Future<int> _getVideoDuration(String videoPath) async {
    try {
      // Using FFmpeg to get duration if FFprobe is not directly exposed
      // ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.mp4
      final tempDir = await getTemporaryDirectory();
      
      // We use a simple command to output duration to a file as a workaround if direct stdout capture is tricky
      final session = await FFmpegKit.execute(
        '-i "$videoPath" -f null - 2>&1'
      );
      
      final logs = await session.getLogs();
      final output = logs.map((l) => l.getMessage()).join('\n');
      
      // Look for "Duration: 00:00:00.00"
      final match = RegExp(r'Duration: (\d+):(\d+):(\d+)\.(\d+)').firstMatch(output);
      if (match != null) {
        final h = int.parse(match.group(1)!);
        final m = int.parse(match.group(2)!);
        final s = int.parse(match.group(3)!);
        return h * 3600 + m * 60 + s;
      }
    } catch (e) {
      developer.log('Failed to get video duration: $e', name: 'AudioSync');
    }
    return 1800; // Default 30 mins
  }

  List<_SyncSegment> _generateDynamicSegments(int durationS, {int? skipMinutes, int? pointDurationMinutes}) {
    if (durationS <= 0) durationS = 1800;

    final int skipS = (skipMinutes ?? 5) * 60;
    final int pointS = (pointDurationMinutes ?? 1) * 60;
    final int intervalS = skipS + pointS;

    // If skip/point are provided, use them directly
    if (skipMinutes != null || pointDurationMinutes != null) {
      final List<_SyncSegment> segments = [];
      // Start slightly earlier to catch the intro
      for (int start = 15; start + pointS < durationS - 30; start += intervalS) {
        segments.add(_SyncSegment(start, pointS));
      }
      // If no segments generated, add at least one in the middle
      if (segments.isEmpty) {
        segments.add(_SyncSegment(max(0, (durationS - pointS) ~/ 2), min(durationS, pointS)));
      }
      return segments;
    }

    int segmentCount;
    if (durationS < 600) { // < 10m
      segmentCount = 2;
    } else if (durationS < 2700) { // < 45m
      segmentCount = 3;
    } else if (durationS < 5400) { // < 90m
      segmentCount = 5;
    } else {
      segmentCount = 7;
    }

    final List<_SyncSegment> segments = [];
    const int startOffset = 60; // Skip first minute
    const int endOffset = 120;  // Avoid very end
    
    int usableDuration = durationS - startOffset - endOffset;
    if (usableDuration < 120) {
      return [_SyncSegment(0, min(durationS, 120))];
    }

    int interval = usableDuration ~/ (segmentCount > 1 ? (segmentCount - 1) : 1);
    
    for (int i = 0; i < segmentCount; i++) {
      int start = startOffset + (i * interval);
      // Ensure we don't go out of bounds
      if (start + 120 > durationS) start = durationS - 120;
      segments.add(_SyncSegment(max(0, start), 120));
    }

    return segments;
  }

  Future<List<double>?> _extractAndGenerateVoiceMap(String videoPath, _SyncSegment seg, VadIterator iterator) async {
    File? audioFile;
    try {
      final tempDir = await getTemporaryDirectory();
      final audioPath = '${tempDir.path}/sync_seg_${seg.startS}_${DateTime.now().millisecondsSinceEpoch}.raw';
      
      final session = await FFmpegKit.execute(
        '-i "$videoPath" -ss ${seg.startS} -t ${seg.durationS} -ar $sampleRate -ac 1 -f s16le "$audioPath"'
      );

      final returnCode = await session.getReturnCode();
      if (!ReturnCode.isSuccess(returnCode)) return null;

      audioFile = File(audioPath);
      final rawBytes = await audioFile.readAsBytes();
      
      // To prevent UI lag during the VAD loop, we can process in chunks
      // or use an Isolate. Since VadIterator has a native pointer, 
      // we must process on the main thread but can yield to the event loop.
      
      final List<double> activity = [];
      final int bytesPerFrame = frameSamples * 2;
      final Int16List pcmData = rawBytes.buffer.asInt16List();
      double currentProb = 0.0;
      
      iterator.setVadEventCallback((event) {
        if (event.type == VadEventType.frameProcessed && event.probabilities != null) {
          currentProb = event.probabilities!.isSpeech;
        }
      });

      // Process in small batches to keep UI responsive
      const int batchSize = 50; 
      for (int i = 0; i < rawBytes.length; i += bytesPerFrame) {
        final end = min(i + bytesPerFrame, rawBytes.length);
        if (end - i < bytesPerFrame) break;
        
        await iterator.processAudioData(rawBytes.sublist(i, end));
        
        if (currentProb < 0.01) {
          double sumSquares = 0;
          int startIdx = i ~/ 2;
          int endIdx = end ~/ 2;
          for (int j = startIdx; j < endIdx; j++) {
            double norm = pcmData[j] / 32768.0;
            sumSquares += norm * norm;
          }
          double rms = sqrt(sumSquares / (endIdx - startIdx));
          activity.add(rms > 0.05 ? 0.1 : 0.0);
        } else {
          activity.add(currentProb);
        }

        // Yield to UI every N frames
        if ((i / bytesPerFrame) % batchSize == 0) {
          await Future.delayed(Duration.zero);
        }
      }

      return activity;
    } catch (e) {
      developer.log('VAD generation failed: $e', name: 'AudioSync');
      return null;
    } finally {
      if (audioFile != null && await audioFile.exists()) {
        await audioFile.delete();
      }
    }
  }

  static Future<_CorrelationResult> _findBestOffsetInIsolate(_CorrelationInput input) async {
    final audio = input.audioSignal;
    final subs = input.subSignal;

    int fftSize = 1;
    while (fftSize < (audio.length + subs.length)) {
      fftSize <<= 1;
    }

    final fft = FFT(fftSize);
    final audioComplex = Float64x2List(fftSize);
    final subsComplex = Float64x2List(fftSize);
    
    double audioMean = audio.reduce((a, b) => a + b) / audio.length;
    double subsMean = subs.reduce((a, b) => a + b) / subs.length;

    for (int i = 0; i < audio.length; i++) {
      audioComplex[i] = Float64x2(audio[i] - audioMean, 0);
    }
    for (int i = 0; i < subs.length; i++) {
      subsComplex[i] = Float64x2(subs[i] - subsMean, 0);
    }

    fft.inPlaceFft(audioComplex);
    fft.inPlaceFft(subsComplex);

    final freqResult = Float64x2List(fftSize);
    for (int i = 0; i < fftSize; i++) {
      double a = audioComplex[i].x;
      double b = audioComplex[i].y;
      double c = subsComplex[i].x;
      double d = subsComplex[i].y;
      freqResult[i] = Float64x2(a * c + b * d, b * c - a * d);
    }

    fft.inPlaceInverseFft(freqResult);
    final realValues = freqResult.toRealArray();
    
    double maxVal1 = -double.infinity;
    int bestIdx1 = 0;
    double maxVal2 = -double.infinity;
    double sum = 0;
    
    for (int i = 0; i < realValues.length; i++) {
      final val = realValues[i];
      sum += val.abs();
      if (val > maxVal1) {
        maxVal1 = val;
        bestIdx1 = i;
      }
    }

    // Find second best peak outside the exclusion window of the first peak
    // exclusion window is about 1s (32 windows @ 32ms)
    const int exclusion = 32; 
    for (int i = 0; i < realValues.length; i++) {
      final val = realValues[i];
      
      // Handle circular exclusion correctly
      int diff = (i - bestIdx1).abs();
      if (diff > fftSize / 2) diff = fftSize - diff;
      
      if (diff < exclusion) continue;
      
      if (val > maxVal2) {
        maxVal2 = val;
      }
    }

    double averageNoise = (sum - maxVal1) / (realValues.length - 1);
    double confidence = 0.0;
    double pnr = 0.0;
    double uniqueness = 0.0;

    if (averageNoise > 0) {
      pnr = maxVal1 / averageNoise;
      uniqueness = (maxVal1 - maxVal2) / (maxVal1 == 0 ? 1.0 : maxVal1);
      // PNR 8.0 is a good match, 15.0 is excellent.
      confidence = (pnr / 15.0 * (0.5 + 0.5 * uniqueness)).clamp(0.0, 1.0);
    }

    int offsetWindows = bestIdx1;
    if (offsetWindows > fftSize / 2) offsetWindows -= fftSize;

    return _CorrelationResult(offsetWindows, confidence, pnr, uniqueness);
  }

  static List<double> _generateSubtitleActivityMapInIsolate(_SubtitleActivityInput input) {
    final phrases = input.phrases;
    final length = input.length;
    final segmentStartS = input.segmentStartS;
    final windowSizeMs = input.windowSizeMs;

    final List<double> activity = List.filled(length, 0.0);
    final now = DateTime(1970, 1, 1);
    
    // 1. Brackets that usually contain speaker names or sound effects (remove content)
    final bracketRegExp = RegExp(r'[\(\[\{（［｛].*?[\)\]\}）］｝]');
    // 2. Stray noise symbols and monologue/quote brackets (remove only symbols)
    final noiseRegExp = RegExp(r'[♪～〜《》「」『』\(\)（）]');
    // 3. Short interjections and breathing sounds for weight reduction
    final interjectionRegExp = RegExp(r'^[っはぁんアハッすぅ!\?\.\s…｡]+$', caseSensitive: false);

    final segmentStartMs = segmentStartS * 1000;
    final segmentEndMs = segmentStartMs + (length * windowSizeMs);

    for (var phrase in phrases) {
      if (phrase.startTime == null || phrase.endTime == null) continue;
      
      int phraseStartMs = phrase.startTime!.difference(now).inMilliseconds;
      int phraseEndMs = phrase.endTime!.difference(now).inMilliseconds;

      if (phraseEndMs < segmentStartMs || phraseStartMs > segmentEndMs) continue;

      // Clean the text
      String original = phrase.originalPhrase ?? '';
      // Step A: Remove bracketed content (names/SFX)
      String cleanText = original.replaceAll(bracketRegExp, '');
      // Step B: Strip remaining noise symbols
      cleanText = cleanText.replaceAll(noiseRegExp, '').trim();
      
      // If it's purely music or empty after cleaning, it's silence
      if (cleanText.isEmpty) continue;

      int durationMs = phraseEndMs - phraseStartMs;
      if (durationMs <= 0) continue;

      int startWindow = (phraseStartMs - segmentStartMs) ~/ windowSizeMs;
      int endWindow = (phraseEndMs - segmentStartMs) ~/ windowSizeMs;

      // Intelligent Weighting
      double baseWeight = 1.0;
      if (interjectionRegExp.hasMatch(cleanText)) {
        baseWeight = 0.8; // Lower priority for breaths/sighs
      }

      double charsPerSecond = (cleanText.length / (durationMs / 1000.0));
      
      for (int i = startWindow; i <= endWindow && i < length; i++) {
        if (i < 0) continue;
        double weight = baseWeight;
        // Adjusted for Japanese characters precision
        if (charsPerSecond < 2.5) {
          int msIntoPhrase = ((i + (segmentStartMs ~/ windowSizeMs)) * windowSizeMs) - phraseStartMs;
          if (msIntoPhrase > 1000) {
            weight = max(0.0, baseWeight * (1.0 - (msIntoPhrase - 1000) / (durationMs - 1000)));
          }
        }
        activity[i] = max(activity[i], weight);
      }
    }
    return activity;
  }

  SyncResult _consolidateResults(List<_CorrelationResult> results) {
    if (results.isEmpty) {
      return SyncResult(
        type: SyncMatchResultType.mismatch,
        explanation: 'No voice activity matched these subtitles in any segment.',
      );
    }

    if (results.length == 1) {
      final r = results.first;
      final offsetMs = r.offsetWindows * windowSizeMs;
      String expl = 'Match found in one segment. ';
      if (r.pnr < 8) expl += 'Signal is weak. ';
      if (r.uniqueness < 0.3) expl += 'Multiple possible offsets found.';

      return SyncResult(
        type: offsetMs.abs() < 250 ? SyncMatchResultType.perfect : SyncMatchResultType.offset,
        offset: Duration(milliseconds: offsetMs),
        confidence: r.confidence * 0.45,
        explanation: expl.trim(),
        pnr: r.pnr,
        uniqueness: r.uniqueness,
        consensusCount: 1,
      );
    }

    final Map<int, List<_CorrelationResult>> clusters = {};
    for (var r in results) {
      final offsetMs = r.offsetWindows * windowSizeMs;
      bool addedToCluster = false;
      for (var clusterOffset in clusters.keys) {
        if ((offsetMs - clusterOffset).abs() < 500) {
          clusters[clusterOffset]!.add(r);
          addedToCluster = true;
          break;
        }
      }
      if (!addedToCluster) clusters[offsetMs] = [r];
    }

    int bestClusterOffset = 0;
    List<_CorrelationResult> bestCluster = [];
    for (var entry in clusters.entries) {
      if (entry.value.length > bestCluster.length) {
        bestClusterOffset = entry.key;
        bestCluster = entry.value;
      } else if (entry.value.length == bestCluster.length && bestCluster.isNotEmpty) {
        // If same size, pick one with higher average confidence
        double currentAvg = entry.value.fold(0.0, (s, r) => s + r.confidence);
        double bestAvg = bestCluster.fold(0.0, (s, r) => s + r.confidence);
        if (currentAvg > bestAvg) {
          bestClusterOffset = entry.key;
          bestCluster = entry.value;
        }
      }
    }

    double avgPnr = bestCluster.fold(0.0, (sum, r) => sum + r.pnr) / bestCluster.length;
    double avgUniq = bestCluster.fold(0.0, (sum, r) => sum + r.uniqueness) / bestCluster.length;
    double totalConfidence = bestCluster.fold(0.0, (sum, r) => sum + r.confidence) / bestCluster.length;
    
    // Scale confidence based on consensus relative to total segments checked
    // We don't have total segments here directly, but we can infer from results.length if they are all valid
    // For now, use a heuristic. 
    if (bestCluster.length >= 2) {
      totalConfidence = min(1.0, totalConfidence * (1.2 + (bestCluster.length * 0.1)));
    }

    String expl = '';
    if (bestCluster.length == results.length && results.length >= 3) {
      expl = 'Perfect consensus: all video segments agree on this timing.';
    } else if (bestCluster.length >= results.length / 2 + 1) {
      expl = 'High consensus: majority of segments match.';
    } else {
      expl = 'Low consensus: segments differ in timing.';
    }

    if (avgPnr > 12) expl += ' Strong voice signal detected.';
    if (avgUniq < 0.25) expl += ' Warning: ambiguous match (multiple peaks).';

    final finalOffset = Duration(milliseconds: bestClusterOffset);
    if (bestCluster.length >= 2 || totalConfidence > 0.4) {
       return SyncResult(
        type: bestClusterOffset.abs() < 250 ? SyncMatchResultType.perfect : SyncMatchResultType.offset,
        offset: finalOffset,
        confidence: totalConfidence,
        explanation: expl.trim(),
        pnr: avgPnr,
        uniqueness: avgUniq,
        consensusCount: bestCluster.length,
      );
    }
    return SyncResult(
      type: SyncMatchResultType.mismatch, 
      confidence: totalConfidence,
      explanation: 'Unreliable match. $expl'.trim(),
      pnr: avgPnr,
      uniqueness: avgUniq,
      consensusCount: bestCluster.length,
    );
  }
}

class _CorrelationResult {
  final int offsetWindows;
  final double confidence;
  final double pnr;
  final double uniqueness;
  _CorrelationResult(this.offsetWindows, this.confidence, this.pnr, this.uniqueness);
}

extension on _CorrelationResult {
  // Add any internal helpers here if needed
}

String _formatTimeRange(int startS, int durationS) {
  String format(int s) {
    int m = s ~/ 60;
    int sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
  return '${format(startS)} - ${format(startS + durationS)}';
}

Phrase? _findRepresentativePhrase(List<Phrase> phrases, int startS, int durationS) {
  final now = DateTime(1970, 1, 1);
  final startMs = startS * 1000;
  final endMs = (startS + durationS) * 1000;
  
  for (var p in phrases) {
    if (p.startTime == null) continue;
    final pStartMs = p.startTime!.difference(now).inMilliseconds;
    // Pick a phrase that starts well within the segment and has enough content
    if (pStartMs >= startMs && pStartMs <= endMs) {
      final text = p.originalPhrase ?? '';
      // Avoid very short snippets, noise, or single characters
      if (text.length > 8 && !text.contains('♪') && text.trim().length > 1) {
        return p;
      }
    }
  }
  // Fallback: pick any phrase in the segment if no good ones found, but try to avoid noise
  for (var p in phrases) {
    if (p.startTime == null) continue;
    final pStartMs = p.startTime!.difference(now).inMilliseconds;
    if (pStartMs >= startMs && pStartMs <= endMs) {
      final text = p.originalPhrase ?? '';
      if (text.trim().length > 2 && !text.contains('♪')) return p;
    }
  }
  return null;
}
