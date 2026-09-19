import 'package:ffmpeg_kit_flutter_new_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_audio/return_code.dart';
import 'package:ffmpeg_kit_flutter_new_audio/ffprobe_kit.dart';
import '../../../utils/logger.dart';

class FFmpegService {
  /// Retrieves the duration of a media file in seconds.
  Future<int?> getDuration(String path) async {
    try {
      final session = await FFmpegKit.execute('-i "$path"');
      final logs = await session.getLogs();
      final output = logs.map((l) => l.getMessage()).join('\n');
      
      final match = RegExp(r'Duration: (\d+):(\d+):(\d+)\.(\d+)').firstMatch(output);
      if (match != null) {
        final h = int.parse(match.group(1)!);
        final m = int.parse(match.group(2)!);
        final s = int.parse(match.group(3)!);
        return h * 3600 + m * 60 + s;
      }
    } catch (e) {
      logger.e('[FFmpegService] Error getting duration: $e');
    }
    return null;
  }

  /// Extracts audio from a video file for a specific time range.
  Future<bool> extractAudio({
    required String inputPath,
    required String outputPath,
    required int startSeconds,
    required int durationSeconds,
    int bitRateKbps = 128,
  }) async {
    final session = await FFmpegKit.execute(
      '-ss $startSeconds -t $durationSeconds -i "$inputPath" -vn -acodec libmp3lame -b:a ${bitRateKbps}k "$outputPath"'
    );
    
    final returnCode = await session.getReturnCode();
    if (!ReturnCode.isSuccess(returnCode)) {
      final logs = await session.getLogs();
      logger.e('[FFmpegService] Extraction failed at $startSeconds: ${logs.lastOrNull?.getMessage()}');
      return false;
    }
    return true;
  }

  /// Extracts a raw audio segment (WAV) for analysis (like VAD).
  Future<bool> extractRawAudio({
    required String inputPath,
    required String outputPath,
    required int startSeconds,
    required int durationSeconds,
    int sampleRate = 16000,
  }) async {
    final session = await FFmpegKit.execute(
      '-ss $startSeconds -t $durationSeconds -i "$inputPath" -vn -ac 1 -ar $sampleRate -f wav "$outputPath"'
    );
    
    final returnCode = await session.getReturnCode();
    return ReturnCode.isSuccess(returnCode);
  }
}
