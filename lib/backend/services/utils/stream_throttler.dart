import 'dart:async';

extension StreamThrottleExtension<T> on Stream<T> {
  Stream<T> throttle(Duration duration) {
    Timer? timer;
    bool hold = false;
    
    return transform(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        if (!hold) {
          sink.add(data);
          hold = true;
          timer = Timer(duration, () {
            hold = false;
          });
        }
      },
      handleDone: (sink) {
        timer?.cancel();
        sink.close();
      },
    ));
  }
}
