import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/secure_storage.dart';
import '../../../providers/services/token_provider.dart';
import '../../../models/settings/guide_step.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';

class ApiKeyConfigScreen extends ConsumerStatefulWidget {
  final ApiTokenType type;
  final String title;
  final String description;
  final List<Color> iconGradient;
  final IconData icon;
  final List<GuideStep> steps;

  const ApiKeyConfigScreen({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.iconGradient,
    required this.icon,
    required this.steps,
  });

  @override
  ConsumerState<ApiKeyConfigScreen> createState() => _ApiKeyConfigScreenState();
}

class _ApiKeyConfigScreenState extends ConsumerState<ApiKeyConfigScreen> {
  late TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final tokenAsync = ref.watch(tokenProvider(widget.type));
    
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBar(
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: theme.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: theme.backgroundColor.withValues(alpha: 0.9),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: theme.dividerColor, height: 1),
          ),
        ),
      ),
      body: tokenAsync.when(
        data: (token) {
          if (_controller.text.isEmpty && token.isNotEmpty) {
            _controller.text = token;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // API Key Input Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'API SECRET KEY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.mutedText,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final data = await Clipboard.getData('text/plain');
                            if (data?.text != null) {
                              _controller.text = data!.text!;
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.copy_rounded, size: 14),
                          label: const Text('Paste key', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(foregroundColor: theme.primaryAccent),
                        ),
                        if (token.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => _handleDelete(),
                            icon: const Icon(Icons.delete_outline_rounded, size: 14),
                            label: const Text('Remove', style: TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _controller,
                  obscureText: _obscureText,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: theme.normalText,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.type == ApiTokenType.gemini ? 'AIzaSy...' : 'jmk_live_...',
                    isDense: true,
                    filled: true,
                    fillColor: theme.isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.slate50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.primaryAccent),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                  onChanged: (val) => setState(() {}),
                ),
                const SizedBox(height: 24),

                // Guide Section
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.isDark ? Colors.white.withValues(alpha: 0.03) : AppColors.slate50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: theme.primaryAccent.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.info_outline_rounded, color: theme.primaryAccent, size: 14),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'GUIDE: HOW TO GET A FREE KEY',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: theme.titleColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.successBg,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Text(
                                '100% Free',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.successText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: widget.steps.length,
                            itemBuilder: (context, index) {
                              final step = widget.steps[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: index == 0 ? theme.primaryAccent : theme.dividerColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: index == 0 ? Colors.white : theme.mutedText,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            step.title,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: theme.titleColor,
                                            ),
                                          ),
                                          if (step.subtitle != null) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              step.subtitle!,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: theme.mutedText,
                                              ),
                                            ),
                                          ],
                                          if (step.link != null) ...[
                                            const SizedBox(height: 8),
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                try {
                                                  final url = Uri.parse(step.link!);
                                                  if (await canLaunchUrl(url)) {
                                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                                  }
                                                } catch (e) {
                                                  debugPrint('Error launching URL: $e');
                                                }
                                              },
                                              icon: const Icon(Icons.open_in_new_rounded, size: 10),
                                              label: Text(step.linkLabel ?? 'Open'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: theme.primaryAccent,
                                                elevation: 0,
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                minimumSize: Size.zero,
                                                side: BorderSide(color: theme.brandBlue100),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(color: theme.dividerColor, height: 1),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.successText, size: 14),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.type == ApiTokenType.gemini
                                    ? 'Generous Free Tier: Full access with high-speed models, up to 15 requests/min. 100% free with no credit card required.'
                                    : 'Developer Access: You must have an API token to use the features. 100% free with no credit card required.',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: theme.mutedText,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  foregroundColor: theme.cancelButtonText,
                  side: BorderSide(color: theme.dividerColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleSave(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  backgroundColor: theme.addButtonBackground,
                  foregroundColor: theme.addButtonText,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final newKey = _controller.text.trim();
    if (newKey.isNotEmpty) {
      await ref.read(tokenProvider(widget.type).notifier).setToken(newKey);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _handleDelete() async {
    final theme = AdditionalWindowTheme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardBackground,
        title: Text('Remove API Key?', style: TextStyle(color: theme.titleColor)),
        content: Text('This will disable AI translation features until a new key is added.', style: TextStyle(color: theme.normalText)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel', style: TextStyle(color: theme.mutedText))),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(tokenProvider(widget.type).notifier).deleteToken();
      _controller.clear();
      if (mounted) setState(() {});
    }
  }
}
