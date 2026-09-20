import 'package:appocrm/services/voice_note_service.dart';
import 'package:appocrm/theme/app_theme.dart';
import 'package:appocrm/widgets/app_card.dart';
import 'package:flutter/material.dart';

class VoiceNoteCapture extends StatefulWidget {
  const VoiceNoteCapture({
    super.key,
    required this.onSaved,
  });

  final Future<void> Function(String text) onSaved;

  @override
  State<VoiceNoteCapture> createState() => _VoiceNoteCaptureState();
}

class _VoiceNoteCaptureState extends State<VoiceNoteCapture>
    with SingleTickerProviderStateMixin {
  final _voice = VoiceNoteService();
  bool _listening = false;
  String _partial = '';
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  Future<void> _toggle() async {
    if (_listening) {
      await _voice.stopListening();
      _pulse.stop();
      setState(() => _listening = false);
      return;
    }

    setState(() {
      _listening = true;
      _partial = '';
    });
    _pulse.repeat(reverse: true);

    await _voice.startListening(
      onPartial: (words) => setState(() => _partial = words),
      onFinal: (text) async {
        await _voice.stopListening();
        _pulse.stop();
        if (!mounted) return;
        setState(() => _listening = false);
        await widget.onSaved(text);
        if (mounted) {
          setState(() => _partial = '');
        }
      },
      onError: (message) {
        if (!mounted) return;
        _pulse.stop();
        setState(() => _listening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    _voice.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentVoice.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.mic_rounded, color: AppColors.accentVoice),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Voice note', style: theme.textTheme.titleMedium),
                    Text(
                      _listening ? 'Listening…' : 'Capture after the call',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_partial.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(_partial, style: theme.textTheme.bodyLarge),
            ),
          ],
          const SizedBox(height: 16),
          ScaleTransition(
            scale: Tween<double>(begin: 1, end: 1.02).animate(
              CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
            ),
            child: FilledButton.icon(
              onPressed: _toggle,
              style: FilledButton.styleFrom(
                backgroundColor:
                    _listening ? AppColors.accentVoice : AppColors.primary,
              ),
              icon: Icon(_listening ? Icons.stop_rounded : Icons.mic_none_rounded),
              label: Text(_listening ? 'Stop recording' : 'Record voice note'),
            ),
          ),
        ],
      ),
    );
  }
}
