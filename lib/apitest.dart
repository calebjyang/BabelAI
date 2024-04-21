import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  // Access your API key as an environment variable (see "Set up your API key" above)
  const apiKey = bool.hasEnvironment('API_KEY') ? String.fromEnvironment('API_KEY', defaultValue: 'NO_KEY') : null;
  if (apiKey == null) {
    print('No \$API_KEY environment variable');
    exit(1);
  }
  // For text-only input, use the gemini-pro model
  final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 200));
  // Initialize the chat
  final chat = model.startChat(history: [
      Content.text('Hello, I am going to have a conversation with a friend who is around my age in Spanish. You are going to receive a transcription as the conversation goes and help me communicate with this stranger. Please include no additional comments in your replies.'),
    Content.model([TextPart('Great to meet you.')])
  ]);
  var content = Content.text('The friend says the following line. Please translate the following message from Mexican Spanish to English: "Hola, como estas? Hace mucho que no nos hemos visto"');
  var response = await chat.sendMessage(content);
  print(response.text);

  content = Content.text('I am going to respond to this message with this response: "I have been alright. I recently got a new job." Please provide a list of three potential tone words to describe the tone of my response to my friend.');
  response = await chat.sendMessage(content);
  print(response.text);

  content = Content.text('Using the list of tone words you just generated, please translate my response into Spanish in those tones');
  response = await chat.sendMessage(content);
  print(response.text);

  content = Content.text('The friend says the following line. Please translate the following message from Mexican Spanish to English: "Me alegro por ti! Pero que paso con el otro trabajo?"');
  response = await chat.sendMessage(content);
  print(response.text);

  content = Content.text('I am going to respond to this message with this response: "Because of COVID, the company was forced to downsize. In order to avoid going under, the company fired me any many others." Please provide a list of three potential tone words to describe the tone of my response to my friend.');
  response = await chat.sendMessage(content);
  print(response.text);

  content = Content.text('Using the list of tone words you just generated, please translate my response into Spanish in those tones');
  response = await chat.sendMessage(content);
  print(response.text);
}