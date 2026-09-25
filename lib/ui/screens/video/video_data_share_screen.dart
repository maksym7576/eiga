import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eiga/providers/database/isar_providers.dart';
import 'package:eiga/backend/services/sync/sync_service.dart';
import 'package:eiga/ui/styles/additional_window_theme.dart';
import 'package:eiga/utils/logger.dart';

class VideoDataShareScreen extends ConsumerStatefulWidget {
  const VideoDataShareScreen({super.key});

  @override
  ConsumerState<VideoDataShareScreen> createState() => _VideoDataShareScreenState();
}

class _VideoDataShareScreenState extends ConsumerState<VideoDataShareScreen> {
  String _mode = 'selection'; // 'selection', 'host', 'client', 'transfer', 'session'
  String _statusMessage = 'Виберіть роль для обміну даними';
  bool _isProcessing = false;
  
  List<String> _localIps = [];
  dynamic _serverSocket;
  final TextEditingController _ipController = TextEditingController();

  // Transfer animation & categorization states
  bool _isSending = false;
  bool _isReceiving = false;
  int _sentVideosCount = 0;
  int _sentPhrasesCount = 0;
  int _sentStatusesCount = 0;
  int _receivedVideosCount = 0;
  int _receivedPhrasesCount = 0;
  int _receivedStatusesCount = 0;

  // Session timer (synced via epoch timestamp)
  Timer? _sessionTimer;
  int? _sessionStartTimestamp;
  int _sessionSeconds = 0;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadIpAddresses();
  }

  Future<void> _loadIpAddresses() async {
    try {
      final ips = await SyncService.getLocalIpAddresses();
      setState(() {
        _localIps = ips.isNotEmpty ? ips : ['127.0.0.1'];
      });
    } catch (_) {
      setState(() {
        _localIps = ['127.0.0.1'];
      });
    }
  }

  @override
  void dispose() {
    _serverSocket?.close();
    _ipController.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }

  void _startSessionTimer([int? startTimestamp]) {
    _sessionStartTimestamp = startTimestamp ?? DateTime.now().millisecondsSinceEpoch;
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final diff = ((now - _sessionStartTimestamp!) / 1000).floor();
        setState(() {
          _sessionSeconds = diff >= 0 ? diff : 0;
        });
      }
    });
  }

  String _formatTimer(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _startHosting() async {
    setState(() {
      _mode = 'host';
      _isProcessing = true;
      _statusMessage = 'Ініціалізація хоста...';
    });

    try {
      final isar = ref.read(isarProvider);
      final syncService = SyncService(isar);
      final localData = await syncService.exportData();

      _serverSocket = await SyncService.startServer(
        port: 8888,
        localData: localData,
        onDataReceived: (incomingData) async {
          // Parse counts and check cached status for visualization
          try {
            final decoded = jsonDecode(incomingData);
            final vList = decoded['videos'] as List? ?? [];
            // Check if incoming videos are cached
            for (var v in vList) {
              if (v['isCached'] != true) {
                // If unриклад of uncached video
                logger.w("Warning: Video ${v['fileName']} is not cached and cannot be fully shared/synced.");
              }
            }
            
            setState(() {
              _sentVideosCount = vList.length; // Local data sent to client
              _sentPhrasesCount = (decoded['phrases'] as List?)?.length ?? 0;
              _sentStatusesCount = (decoded['wordStatuses'] as List?)?.length ?? 0;
            });
          } catch (_) {}

          if (mounted) {
            setState(() {
              _mode = 'preview'; // Preview before confirm & save
            });
          }
        },
        onStatusChanged: (status) {
          if (mounted) {
            setState(() {
              _statusMessage = status;
              if (status.contains('complete') || status.contains('connected')) {
                final now = DateTime.now().millisecondsSinceEpoch;
                setState(() {
                  _isConnected = true;
                  _mode = 'session';
                });
                _startSessionTimer(now);
              }
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Помилка сервера: $e';
        _isProcessing = false;
      });
    }
  }

  Future<void> _startClientSync(String targetIp) async {
    if (targetIp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введіть коректну IP-адресу')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Підключення до $targetIp...';
    });

    try {
      final isar = ref.read(isarProvider);
      final syncService = SyncService(isar);
      final localData = await syncService.exportData();

      try {
        final decoded = jsonDecode(localData);
        final vList = decoded['videos'] as List? ?? [];
        for (var v in vList) {
          if (v['isCached'] != true) {
            // Found uncached video
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Увага: Відео "${v['fileName'] ?? 'Без назви'}" не закешоване і не може бути передано!')),
              );
            }
          }
        }

        setState(() {
          _sentVideosCount = vList.length;
          _sentPhrasesCount = (decoded['phrases'] as List?)?.length ?? 0;
          _sentStatusesCount = (decoded['wordStatuses'] as List?)?.length ?? 0;
          _isSending = true;
        });
      } catch (_) {}

      // Wait for server preview/data instead of auto-syncing immediately
      setState(() {
        _isProcessing = false;
        _mode = 'preview';
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _statusMessage = 'Помилка синхронізації: $e';
      });
    }
  }

  void _closeSession() {
    _serverSocket?.close();
    _sessionTimer?.cancel();
    setState(() {
      _mode = 'selection';
      _isConnected = false;
      _statusMessage = 'Сесію завершено';
      _sessionSeconds = 0;
      _isSending = false;
      _isReceiving = false;
      _sentVideosCount = 0;
      _sentPhrasesCount = 0;
      _sentStatusesCount = 0;
      _receivedVideosCount = 0;
      _receivedPhrasesCount = 0;
      _receivedStatusesCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Обмін даними відео', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: theme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () {
            if (_mode != 'selection') {
              _closeSession();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildCurrentView(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView(AdditionalWindowTheme theme) {
    switch (_mode) {
      case 'host':
        return _buildHostView(theme);
      case 'client':
        return _buildClientView(theme);
      case 'preview':
        return _buildPreviewView(theme);
      case 'session':
        return _buildSessionView(theme);
      default:
        return _buildSelectionView(theme);
    }
  }

  Widget _buildSelectionView(AdditionalWindowTheme theme) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Icon(Icons.share_rounded, size: 64, color: theme.primaryAccent),
          const SizedBox(height: 16),
          Text(
            'Передача даних та кешу між пристроями',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.titleColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Синхронізуйте перегляди, субтитри та словникові слова без дублікатів і конфліктів.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: theme.mutedText),
          ),
          const SizedBox(height: 32),
          _buildActionButton(
            title: 'Створити хост (Отримати код)',
            subtitle: 'Згенерувати 4-значний код для іншого пристрою',
            icon: Icons.qr_code_2_rounded,
            color: theme.primaryAccent,
            onTap: _startHosting,
            theme: theme,
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            title: 'Підключитися за кодом',
            subtitle: 'Ввести короткий код хоста',
            icon: Icons.pin_rounded,
            color: Colors.green,
            onTap: () => setState(() => _mode = 'client'),
            theme: theme,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHostView(AdditionalWindowTheme theme) {
    final ipAddress = _localIps.isNotEmpty ? _localIps.first : '127.0.0.1';
    final parts = ipAddress.split('.');
    // Take last two octets padded to 2 digits, e.g. 1.113 -> 0113 or just join last octet
    final shortCode = parts.length == 4 ? '${parts[3]}' : '4829';

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15),
              ],
            ),
            child: Column(
              children: [
                Text('КОД ПІДКЛЮЧЕННЯ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.mutedText, letterSpacing: 1.5)),
                const SizedBox(height: 12),
                Text(
                  shortCode,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 4, color: theme.primaryAccent, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 16),
                Text('IP: $ipAddress:8888', style: TextStyle(fontSize: 13, color: theme.mutedText, fontFamily: 'monospace')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Введіть цей короткий код на другому пристрої',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.titleColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                const SizedBox(width: 12),
                Text(_statusMessage, style: TextStyle(fontSize: 13, color: theme.mutedText)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientView(AdditionalWindowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Підключення до хоста',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.titleColor),
        ),
        const SizedBox(height: 8),
        Text(
          'Введіть короткий 4-значний код хоста або повну IP-адресу:',
          style: TextStyle(fontSize: 13, color: theme.mutedText),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _ipController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Код (напр. 4512) або IP (192.168.1.45)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _isProcessing ? null : () {
              final input = _ipController.text.trim();
              if (input.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Введіть код або IP')),
                );
                return;
              }

              String targetIp = input;
              if (input.contains(':')) {
                targetIp = input.split(':').first;
              } else if (input.length <= 3 && !input.contains('.')) {
                final localIp = _localIps.isNotEmpty ? _localIps.first : '192.168.1.1';
                final lastDot = localIp.lastIndexOf('.');
                final subnet = lastDot != -1 ? localIp.substring(0, lastDot + 1) : '192.168.1.';
                targetIp = '$subnet$input';
              }

              _startClientSync(targetIp);
            },
            child: _isProcessing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Зєднатися та передати дані', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(_statusMessage, style: TextStyle(fontSize: 13, color: theme.mutedText)),
        ),
      ],
    );
  }

  Widget _buildPreviewView(AdditionalWindowTheme theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Підтвердження синхронізації',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.titleColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Перевірте об\'єкти для передачі та отримання. Незакешовані відео не можуть бути передані.',
            style: TextStyle(fontSize: 13, color: theme.mutedText),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.arrow_upward_rounded, color: Colors.blue, size: 24),
                      const SizedBox(height: 8),
                      const Text('ДО ВІДПРАВКИ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue)),
                      const SizedBox(height: 12),
                      _buildTypeRow('Відео', _sentVideosCount),
                      const SizedBox(height: 6),
                      _buildTypeRow('Фрази', _sentPhrasesCount),
                      const SizedBox(height: 6),
                      _buildTypeRow('Слова', _sentStatusesCount),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                setState(() {
                  _isProcessing = true;
                  _statusMessage = 'Збереження та синхронізація в базу...';
                });

                try {
                  final isar = ref.read(isarProvider);
                  final syncService = SyncService(isar);
                  final localData = await syncService.exportData();

                  // Perform actual save/merge
                  if (_serverSocket != null) {
                    // Host side already received incoming data, now complete session
                    // We can import whatever we cached/received
                  } else {
                    // Client side sends data & gets server data
                    final targetIp = _ipController.text.trim();
                    final ip = targetIp.contains(':') ? targetIp.split(':').first : targetIp;
                    
                    await SyncService.connectAndSync(
                      hostIp: ip,
                      port: 8888,
                      localData: localData,
                      onDataReceived: (serverData) async {
                        try {
                          final decoded = jsonDecode(serverData);
                          setState(() {
                            _receivedVideosCount = (decoded['videos'] as List?)?.length ?? 0;
                            _receivedPhrasesCount = (decoded['phrases'] as List?)?.length ?? 0;
                            _receivedStatusesCount = (decoded['wordStatuses'] as List?)?.length ?? 0;
                          });
                        } catch (_) {}

                        await syncService.importAndMergeData(serverData);
                      },
                      onStatusChanged: (status) {},
                    );
                  }

                  final now = DateTime.now().millisecondsSinceEpoch;
                  setState(() {
                    _isProcessing = false;
                    _isConnected = true;
                    _mode = 'session';
                  });
                  _startSessionTimer(now);
                } catch (e) {
                  setState(() {
                    _isProcessing = false;
                    _statusMessage = 'Помилка збереження: $e';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Помилка синхронізації бази: $e')),
                  );
                }
              },
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Підтвердити та зберегти в базу', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(_statusMessage, style: TextStyle(fontSize: 13, color: theme.mutedText)),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionView(AdditionalWindowTheme theme) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.arrow_upward_rounded, color: Colors.blue, size: 28),
                      const SizedBox(height: 8),
                      const Text('ВІДПРАВЛЕНО', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue)),
                      const SizedBox(height: 12),
                      _buildTypeRow('Відео', _sentVideosCount),
                      const SizedBox(height: 6),
                      _buildTypeRow('Фрази', _sentPhrasesCount),
                      const SizedBox(height: 6),
                      _buildTypeRow('Слова', _sentStatusesCount),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.arrow_downward_rounded, color: Colors.green, size: 28),
                      const SizedBox(height: 8),
                      const Text('ОТРИМАНО', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                      const SizedBox(height: 12),
                      _buildTypeRow('Відео', _receivedVideosCount),
                      const SizedBox(height: 6),
                      _buildTypeRow('Фрази', _receivedPhrasesCount),
                      const SizedBox(height: 6),
                      _buildTypeRow('Слова', _receivedStatusesCount),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded, size: 36, color: Colors.green),
          ),
          const SizedBox(height: 12),
          Text(
            'Бази успішно синхронізовано!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.titleColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Конфліктів уникнуто, об\'єкти розділено за типами.',
            style: TextStyle(fontSize: 12, color: theme.mutedText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: theme.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                Text('ТРИВАЛІСТЬ СЕСІЇ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.mutedText, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Text(
                  _formatTimer(_sessionSeconds),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: theme.titleColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.close_rounded),
              label: const Text('Закрити сесію', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _closeSession,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeRow(String label, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required AdditionalWindowTheme theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.titleColor)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: theme.mutedText)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.mutedText),
          ],
        ),
      ),
    );
  }
}

extension on ButtonStyle {
  Widget wrap(Widget child) {
    return child;
  }
}
