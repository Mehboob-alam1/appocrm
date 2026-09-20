import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceNoteService {
  VoiceNoteService() : _speech = SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;
  String _lastWords = '';

  Future<bool> ensureReady() async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) return false;

    if (!_initialized) {
      _initialized = await _speech.initialize();
    }
    return _initialized;
  }

  bool get isListening => _speech.isListening;

  String get lastWords => _lastWords;

  /// Listen until [stopListening] — no auto-save on silence (long pause window).
  Future<void> startListening({
    required void Function(String words) onPartial,
    required void Function(String message) onError,
  }) async {
    final ready = await ensureReady();
    if (!ready) {
      onError('Microphone or speech recognition not available.');
      return;
    }

    _lastWords = '';
    await _speech.listen(
      onResult: (result) {
        _lastWords = result.recognizedWords;
        onPartial(_lastWords);
      },
      listenFor: const Duration(minutes: 15),
      pauseFor: const Duration(minutes: 15),
      localeId: null,
      cancelOnError: false,
      partialResults: true,
    );
  }

  Future<String> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
    return _lastWords.trim();
  }
}
