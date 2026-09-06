import 'package:flutter/material.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'eiga_logo.dart';

class LoadingSplash extends StatelessWidget {
  const LoadingSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EigaLogo(size: 64),
            const SizedBox(height: 24),
            Text(
              'Preparing your experience...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.mutedText.withOpacity(0.7),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
