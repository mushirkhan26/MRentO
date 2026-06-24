import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceSearchService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize({Function(String)? onErrorCallback}) async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speechToText.initialize(
        onError: (error) {
          debugPrint('VoiceSearch Error: $error');
          onErrorCallback?.call(error.errorMsg);
        },
        onStatus: (status) => debugPrint('VoiceSearch Status: $status'),
      );
      return _isInitialized;
    } catch (e) {
      debugPrint('VoiceSearch Initialization Failed: $e');
      onErrorCallback?.call(e.toString());
      return false;
    }
  }

  Future<void> startListening({
    required Function(String) onResult,
    required VoidCallback onDone,
    required Function(String) onError,
  }) async {
    bool available = await initialize(onErrorCallback: onError);
    if (available) {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
            onDone();
          }
        },
        localeId: 'hi_IN', // Defaulting to Hindi for better Hinglish recognition
        cancelOnError: true,
        listenMode: ListenMode.search,
      );
    } else {
      onError('Voice search not available. Please check permissions.');
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  bool get isListening => _speechToText.isListening;
}
