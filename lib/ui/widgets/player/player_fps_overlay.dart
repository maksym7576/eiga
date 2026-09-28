import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PlayerFpsOverlay extends HookWidget {
  const PlayerFpsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final fps = useState<double>(60.0);
    
    useEffect(() {
      int frames = 0;
      Stopwatch stopwatch = Stopwatch()..start();
      
      void callback(List<FrameTiming> timings) {
        frames += timings.length;
        if (stopwatch.elapsedMilliseconds >= 500) {
          fps.value = (frames * 1000) / stopwatch.elapsedMilliseconds;
          frames = 0;
          stopwatch.reset();
          stopwatch.start();
        }
      }

      SchedulerBinding.instance.addTimingsCallback(callback);
      return () => SchedulerBinding.instance.removeTimingsCallback(callback);
    }, []);

    return Positioned(
      top: 16,
      right: 16,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white24, width: 0.5),
          ),
          child: Text(
            '${fps.value.toStringAsFixed(1)} FPS',
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: fps.value < 45 ? Colors.redAccent : (fps.value < 55 ? Colors.amber : Colors.greenAccent),
            ),
          ),
        ),
      ),
    );
  }
}
