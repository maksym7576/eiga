import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/providers/services/external_api_providers.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';
import '../../widgets/app_bar/app_blur_header.dart';

class AnkiSettingsScreen extends ConsumerStatefulWidget {
  const AnkiSettingsScreen({super.key});

  @override
  ConsumerState<AnkiSettingsScreen> createState() => _AnkiSettingsScreenState();
}

class _AnkiSettingsScreenState extends ConsumerState<AnkiSettingsScreen> {
  late TextEditingController _urlController;
  late TextEditingController _deckController;
  late TextEditingController _noteTypeController;
  bool _testingConnection = false;
  String? _connectionStatus;
  Color _statusColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    final config = ref.read(appConfigsServiceProvider);
    _urlController = TextEditingController(text: config.getAnkiConnectUrl);
    _deckController = TextEditingController(text: config.getAnkiDeckName);
    _noteTypeController = TextEditingController(text: config.getAnkiNoteType);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _deckController.dispose();
    _noteTypeController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    setState(() {
      _testingConnection = true;
      _connectionStatus = 'Connecting...';
      _statusColor = Colors.blue;
    });

    final config = ref.read(appConfigsServiceProvider);
    await config.setAnkiConnectUrl(_urlController.text.trim());

    final ankiService = ref.read(ankiServiceProvider);
    final isConnected = await ankiService.checkConnection();

    setState(() {
      _testingConnection = false;
      if (isConnected) {
        _connectionStatus = 'Connected Successfully!';
        _statusColor = Colors.teal;
      } else {
        _connectionStatus = 'Failed to connect. Make sure Anki is running with AnkiConnect add-on installed.';
        _statusColor = Colors.redAccent;
      }
    });
  }

  Future<void> _saveSettings() async {
    final config = ref.read(appConfigsServiceProvider);
    await config.setAnkiConnectUrl(_urlController.text.trim());
    await config.setAnkiDeckName(_deckController.text.trim());
    await config.setAnkiNoteType(_noteTypeController.text.trim());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anki settings saved successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: const AppBlurHeader(
        title: 'Anki Integration',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ANKICONNECT CONFIGURATION',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: theme.mutedText,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'AnkiConnect URL',
              controller: _urlController,
              hint: 'http://localhost:8765',
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Deck Name',
              controller: _deckController,
              hint: 'Eiga',
              theme: theme,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Note Type (Model)',
              controller: _noteTypeController,
              hint: 'Basic',
              theme: theme,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _testingConnection ? null : _testConnection,
                    icon: _testingConnection
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.swap_horiz_rounded),
                    label: const Text('Test Connection', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: theme.dividerColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Save Settings', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.addButtonBackground,
                      foregroundColor: theme.addButtonText,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
            if (_connectionStatus != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _statusColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  _connectionStatus!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required AdditionalWindowTheme theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.titleColor),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
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
          ),
        ),
      ],
    );
  }
}
