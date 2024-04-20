import 'package:google_generative_ai/google_generative_ai.dart';

final apiKey = Platform.environment['API_KEY'];
if (apiKey == null) {
  print('No \$API_KEY environment variable');
  exit(1);
}

final model = GenerativeModel(model: 'gemini-1.5-pro-latest', apiKey: apiKey);

