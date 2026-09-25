import 'dart:io';
import 'package:flutter/material.dart';
import '../../styles/additional_window_theme.dart';
import 'desktop/app_sheet_footer_desktop.dart';
import 'mobile/app_sheet_footer_mobile.dart';

class AppSheetFooter extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback? onConfirm;
  final String confirmText;
  final bool isResolving;

  const AppSheetFooter({
    super.key,
    required this.onCancel,
    this.onConfirm,
    this.confirmText = 'Confirm',
    this.isResolving = false,
  });

  bool _isDesktop() {
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final isDesktop = _isDesktop();

    final buttonsContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.normalText,
              side: BorderSide(color: theme.cardBorder),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Cancel',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  theme.primaryAccent,
                  theme.primaryAccent.withValues(alpha: 0.82)
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryAccent.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: ElevatedButton(
              onPressed: onConfirm == null || isResolving ? null : onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: theme.backgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: isResolving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      confirmText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.1,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );

    if (isDesktop) {
      return AppSheetFooterDesktop(
        onCancel: onCancel,
        onConfirm: onConfirm,
        confirmText: confirmText,
        isResolving: isResolving,
        buttonsContent: buttonsContent,
      );
    }

    return AppSheetFooterMobile(
      onCancel: onCancel,
      onConfirm: onConfirm,
      confirmText: confirmText,
      isResolving: isResolving,
      buttonsContent: buttonsContent,
    );
  }
}
