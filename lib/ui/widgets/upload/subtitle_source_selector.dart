import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/redirect_providers.dart';
import '../../../config/secure_storage.dart';
import '../../styles/additional_window_theme.dart';
import '../buttons/equal_toggle_buttons.dart';

class SubtitleSourceSelector extends ConsumerWidget {
  const SubtitleSourceSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitleSource = ref.watch(uploadProvider.select((s) => s.subtitleSource));
    final notifier = ref.read(uploadProvider.notifier);

    return EqualToggleButtons<SubtitleSource>(
      items: SubtitleSource.values,
      activeItem: subtitleSource,
      onChanged: (source) {
        if (source == SubtitleSource.jimaku) {
          _handleJimakuTap(context, ref, notifier);
        } else {
          notifier.setSubtitleSource(source);
        }
      },
      labelBuilder: (source) => source == SubtitleSource.local ? 'Local' : 'Jimaku',
      iconBuilder: (source) => source == SubtitleSource.local ? Icons.folder_open : Icons.cloud_download_outlined,
    );
  }

  void _handleJimakuTap(BuildContext context, WidgetRef ref, UploadNotifier notifier) async {
    final token = await SecureTokenStorage.getToken(ApiTokenType.jimaku);
    if (token.isEmpty) {
      ref.read(openJimakuDialogProvider.notifier).state = true;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter Jimaku API key first')),
        );
        context.go('/settings');
      }
    } else {
      notifier.setSubtitleSource(SubtitleSource.jimaku);
    }
  }
}
