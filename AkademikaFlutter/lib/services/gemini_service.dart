import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class GeminiService {
  // Ganti dengan API Key Anda dari Google AI Studio
  static const String _apiKey = 'AIzaSyDw3c639rGrUriXHoEc4oWJbnGJIht-lfI';
  
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  GenerativeModel? _model;

  GenerativeModel get model {
    _model ??= GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
    return _model!;
  }

  Future<String> getChatResponse(String message, {List<Content>? history}) async {
    try {
      if (_apiKey == 'YOUR_GEMINI_API_KEY') {
        return "API Key Gemini belum diatur. Silakan atur API Key di lib/services/gemini_service.dart";
      }

      final chat = model.startChat(history: history);
      final response = await chat.sendMessage(Content.text(message));
      
      return response.text ?? "Maaf, saya tidak bisa memberikan jawaban saat ini.";
    } catch (e) {
      debugPrint('Gemini Error: $e');
      return "Terjadi kesalahan saat menghubungi asisten AI. Pastikan koneksi internet stabil.";
    }
  }
}
