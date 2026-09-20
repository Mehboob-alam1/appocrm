import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceNoteService {
  VoiceNoteService() : _speech = SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;

  Future<bool> ensureReady() async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) return false;

    if (!_initialized) {
      _initialized = await _speech.initialize();
    }
    return _initialized;
  }

  bool get isListening => _speech.isListening;

  Future<void> startListening({
    required void Function(String words) onPartial,
    required void Function(String finalText) onFinal,
    required void Function(String message) onError,
  }) async {
    final ready = await ensureReady();
    if (!ready) {
      onError('Microphone or speech recognition not available.');
      return;
    }

    var buffer = '';
    await _speech.listen(
      onResult: (result) {
        buffer = result.recognizedWords;
        onPartial(buffer);
        if (result.finalResult && buffer.trim().isNotEmpty) {
          onFinal(buffer.trim());
        }
      },
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 3),
      localeId: null,
      cancelOnError: true,
      partialResults: true,
    );
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
}
