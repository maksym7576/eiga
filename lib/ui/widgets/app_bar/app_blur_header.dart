import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../styles/app_colors.dart';

class AppBlurHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;
  final double height;

  const AppBlurHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = true,
    this.onBack,
    this.height = 52,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            border: const Border(
              bottom: BorderSide(color: AppColors.slate100, width: 0.9),
            ),
          ),
          child: Row(
            children: [
              if (showBackButton) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20, color: AppColors.slate600),
                  onPressed: onBack ?? () => context.pop(),
                ),
              ] else 
                const SizedBox(width: 16),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slate900,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
              if (actions != null) ...[
                ...actions!,
                const SizedBox(width: 4),
              ] else ...[
                const SizedBox(width: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
