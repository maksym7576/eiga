import 'package:flutter/material.dart';

class TranslationGlobalBanner extends StatelessWidget implements PreferredSizeWidget {
  const TranslationGlobalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      color: Colors.blueAccent,
      child: const LinearProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(4);
}
