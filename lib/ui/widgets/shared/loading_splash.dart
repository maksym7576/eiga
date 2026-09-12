import 'package:flutter/material.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import '../animations/eiga_logo_animation.dart';
import 'eiga_logo.dart';
import '../../styles/app_colors.dart';

class LoadingSplash extends StatelessWidget {
  final bool useAlternativeLogo;

  const LoadingSplash({
    super.key,
    this.useAlternativeLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (useAlternativeLogo)
              EigaLogo(
                size: 64,
                color: AppColors.brandBlue,
                isFrequent: true,
              )
            else
              EigaLogoAnimation(
                isFrequent: true,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brandBlue,
                  letterSpacing: -1.0,
                ),
              ),
            const SizedBox(height: 32),
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
