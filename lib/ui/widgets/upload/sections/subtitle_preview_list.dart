import 'package:flutter/material.dart';
import 'package:eiga/backend/database/schemas/phrase.dart';
import '../../../styles/additional_window_theme.dart';
import '../../../styles/app_colors.dart';

class SubtitlePreviewList extends StatelessWidget {
  final List<Phrase> phrases;
  const SubtitlePreviewList({super.key, required this.phrases});

  static String _fmt(DateTime? t) {
    if (t == null) return '--:--';
    final d = t.difference(DateTime(1970, 1, 1));
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    if (phrases.isEmpty) {
      return Text('No lines parsed', style: TextStyle(color: theme.mutedText, fontSize: 12));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.fromBorderSide(BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Row(
            children: [
              const Text(
                'PREVIEW',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1.0),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: Color(0xFFCBD5E1))),
              const SizedBox(width: 8),
              Text(
                '${phrases.length} lines',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569), fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 360),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: phrases.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
            itemBuilder: (_, i) {
              final p = phrases[i];
              final tr = p.translatedPhrase;
              const bool isSpecial = false; 
              
              return Material(
                color: isSpecial ? const Color(0xFFEFF6FF).withValues(alpha: 0.4) : Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: isSpecial ? const BoxDecoration(
                      border: Border(left: BorderSide(color: Color(0xFF2563EB), width: 2.5)),
                    ) : null,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 56,
                          child: Text(
                            _fmt(p.startTime), 
                            style: TextStyle(
                              fontSize: 11, 
                              fontFamily: 'monospace',
                              fontWeight: isSpecial ? FontWeight.bold : FontWeight.w500,
                              color: isSpecial ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)
                            )
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.originalPhrase ?? '', 
                                style: TextStyle(
                                  fontSize: 13, 
                                  fontWeight: isSpecial ? FontWeight.bold : FontWeight.w500,
                                  color: isSpecial ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
                                )
                              ),
                              if (tr != null && tr.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  tr, 
                                  style: TextStyle(
                                    fontSize: 11, 
                                    fontStyle: FontStyle.italic,
                                    color: isSpecial ? const Color(0xFF1E3A8A).withValues(alpha: 0.7) : const Color(0xFF64748B)
                                  )
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
