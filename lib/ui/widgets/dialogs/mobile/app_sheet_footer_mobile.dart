import 'package:flutter/material.dart';
import '../../../styles/additional_window_theme.dart';

class AppSheetFooterMobile extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback? onConfirm;
  final String confirmText;
  final bool isResolving;
  final Widget buttonsContent;

  const AppSheetFooterMobile({
    super.key,
    required this.onCancel,
    this.onConfirm,
    this.confirmText = 'Confirm',
    this.isResolving = false,
    required this.buttonsContent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: buttonsContent,
    );
  }
}
