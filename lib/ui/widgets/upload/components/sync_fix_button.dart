import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';

class SyncFixButton extends HookConsumerWidget {
  final Duration offset;

  const SyncFixButton({
    super.key,
    required this.offset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(uploadProvider.notifier);
    final isSuccess = useState(false);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: isSuccess.value ? 0 : 52,
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isSuccess.value ? 0.0 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSuccess.value 
                  ? [const Color(0xFF10B981), const Color(0xFF059669)]
                  : [const Color(0xFF2563EB), const Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (isSuccess.value ? const Color(0xFF10B981) : const Color(0xFF2563EB)).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: isSuccess.value ? null : () async {
              isSuccess.value = true;
              // Let the user see the green state and animation start
              await Future.delayed(const Duration(milliseconds: 500));
              notifier.applySyncFix(manualOffset: offset);
            },
            // icon: Icon(
            //   isSuccess.value ? null : Icons.auto_fix_high_rounded,
            //   size: 18,
            //   color: Colors.white
            // ),
            label: Text(
              isSuccess.value 
                  ? 'Applied Successfully!'
                  : 'Fix ${offset.inMilliseconds > 0 ? '+' : ''}${offset.inMilliseconds}ms Offset',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              elevation: 0,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }
}
