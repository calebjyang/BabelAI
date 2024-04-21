import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';


class gemAPI {
  gemAPI()
  {     
    const apiKey = bool.hasEnvironment('API_KEY') ? String.fromEnvironment('API_KEY', defaultValue: 'NO_KEY') : null;
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }
    // For text-only input, use the gemini-pro model
    final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
        generationConfig: GenerationConfig(maxOutputTokens: 100));
    // Initialize the chat
    final chat = model.startChat(history: [
      Content.text('Hello, I have 2 dogs in my house.'),
      Content.model([TextPart('Great to meet you. What would you like to know?')])
    ]);
  }
}