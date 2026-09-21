import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoPathNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  set state(String? value) => super.state = value;
}

final videoPathProvider = NotifierProvider<VideoPathNotifier, String?>(
  VideoPathNotifier.new,
);
