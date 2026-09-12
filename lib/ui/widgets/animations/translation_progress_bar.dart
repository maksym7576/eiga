import 'package:flutter/material.dart';

class TranslationProgressBar extends StatelessWidget implements PreferredSizeWidget {
  const TranslationProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      color: Colors.blueAccent.withValues(alpha: 0.1),
      child: const LinearProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(4);
}
