import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String apiKey = 'AIzaSyDHyegvSRytu8QJUQb293cBRW5VM8K7q8s'; 

  static Future<String> translate(String text) async {
    final response = await http.post(
      Uri.parse(
          'https://translation.googleapis.com/language/translate/v2?key=$apiKey'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'q': text,
        'target': 'en', // Target language (English)
        'source': 'es', // Source language (Spanish)
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data']['translations'][0]['translatedText'];
    } else {
      throw Exception('Failed to translate text');
    }
  }
}

