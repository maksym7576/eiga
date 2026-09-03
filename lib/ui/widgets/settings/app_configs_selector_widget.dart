import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/services/app_configs_provider.dart';
import '../../styles/settings_theme.dart';

class AppConfigsSelectorWidget extends ConsumerWidget {
  const AppConfigsSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigsServiceProvider);
    final theme = SettingsTheme.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(
            'App Configuration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: theme.primaryAccent),
          ),
          const SizedBox(height: 24),
          _buildGroup(
            theme: theme,
            title: 'Seconds Before Send',
            subtitle: 'Adjustment for timing (auto-send interval).',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: config.getSecondsAhead.toDouble(),
                      min: 0,
                      max: 600,
                      divisions: 60,
                      activeColor: theme.primaryAccent,
                      onChanged: (val) async {
                        await config.setSecondsAhead(val.toInt());
                        ref.invalidate(appConfigsServiceProvider);
                      },
                    ),
                  ),
                  _EditableValue(
                    value: config.getSecondsAhead,
                    suffix: 's',
                    min: 0,
                    max: 600,
                    theme: theme,
                    onChanged: (val) async {
                      await config.setSecondsAhead(val);
                      ref.invalidate(appConfigsServiceProvider);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildGroup(
            theme: theme,
            title: 'Number of Phrases',
            subtitle: 'Limit for phrases per request.',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: config.getNumberOfPhrases.toDouble(),
                      min: 1,
                      max: 100,
                      divisions: 99,
                      activeColor: theme.primaryAccent,
                      onChanged: (val) async {
                        await config.setNumberOfPhrases(val.toInt());
                        ref.invalidate(appConfigsServiceProvider);
                      },
                    ),
                  ),
                  _EditableValue(
                    value: config.getNumberOfPhrases,
                    min: 1,
                    max: 100,
                    theme: theme,
                    onChanged: (val) async {
                      await config.setNumberOfPhrases(val);
                      ref.invalidate(appConfigsServiceProvider);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              await config.resetToDefault();
              ref.invalidate(appConfigsServiceProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reset to Default'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGroup({
    required SettingsTheme theme,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: theme.normalText),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: theme.mutedText),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.sectionBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.dialogBorder, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditableValue extends StatefulWidget {
  final int value;
  final String suffix;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final SettingsTheme theme;

  const _EditableValue({
    required this.value,
    required this.theme,
    this.suffix = '',
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<_EditableValue> createState() => _EditableValueState();
}

class _EditableValueState extends State<_EditableValue> {
  bool _isEditing = false;
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(_EditableValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _isEditing = false);
    final newVal = int.tryParse(_controller.text);
    if (newVal != null) {
      widget.onChanged(newVal.clamp(widget.min, widget.max));
    } else {
      _controller.text = widget.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    if (_isEditing) {
      return SizedBox(
        width: 60,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          autofocus: true,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.normalText),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _submit(),
          onTapOutside: (_) => _submit(),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditing = true;
          _controller.text = widget.value.toString();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.primaryAccent.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.primaryAccent.withValues(alpha: 0.1)),
        ),
        child: Text(
          '${widget.value}${widget.suffix}',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryAccent),
        ),
      ),
    );
  }
}
