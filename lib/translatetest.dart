import 'googletranslateapi.dart';
void main() async {
  const spanishText = "Hola! Como has estado?"; 
  print("Translating '$spanishText' to English...");

  try {
    final englishTranslation = await TranslationService.translate(spanishText);
    print("English Translation: $englishTranslation");
  } catch (e) {
    print("Error: $e");
  }
}