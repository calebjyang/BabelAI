import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'googletranslateapi.dart';
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _toDisplay = '';
  String _textInput = '';
  bool _isListening = false;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('Initializing speech...');
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    print('Initializing...');
    _speechEnabled = await _speechToText.initialize();
    print('Speech initialized: $_speechEnabled');
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    print('Starting listening...');
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: 'es_ES', // Set the language to Spanish
    );
    setState(() {
      _isListening = true;
      _lastWords = ''; // Clear last words when starting listening
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on
  /// the listen method.
  void _stopListening() async {
    print('Stopping listening...');
    await _speechToText.stop();

    try {
      final englishTranslation = await TranslationService.translate(_lastWords);
      _lastWords = englishTranslation;
      _toDisplay = _lastWords;
      setState(() {
        _isListening = false;
        print('here');
      });
    } catch (e) {
      final englishTranslation = "translation failed :(";
    }
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      // print('Recognized words: $_lastWords');
    });
  }

  void _submitText() {
    setState(() {
      _textInput = _textController.text;
    });
    // Navigate to the new page
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResultPage(
                lastWords: _toDisplay,
                textInput: _textInput,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BabelAI'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  !_isListening ? _toDisplay : '',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: FloatingActionButton(
                        onPressed:
                            _isListening ? _stopListening : _startListening,
                        tooltip: _isListening ? 'Stop Listening' : 'Listen',
                        child: Icon(_isListening ? Icons.mic : Icons.mic_off),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Text',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _submitText,
                        child: Icon(Icons.arrow_upward),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox.shrink(),
    );
  }
}

class ResultPage extends StatefulWidget {
  final String lastWords;
  final String textInput;

  ResultPage({Key? key, required this.lastWords, required this.textInput})
      : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  FlutterTts flutterTts = FlutterTts();
  late String _displayedText;
  late String _textInput;

  late GenerativeModel _model;
  late ChatSession _chat;

  String response1 = 'Processing...';
  String response2 = 'Processing...';
  String response3 = 'Processing...';
  
  String eng1 = 'Processing...';
  String eng2 = 'Processing...';
  String eng3 = 'Processing...';

  String tone1 = '';
  String tone2 = '';
  String tone3 = '';

  Future<String> getresponse(
      String context, ChatSession chat, String str) async {
    var content;
    var response;
    content = Content.text(
        'The friend tells me the following: "$context". I am going to respond to this message with this response: "$str" Please provide a list of three potential tone words to describe the tone of my response to my friend.');
    await chat.sendMessage(content);

    content = Content.text(
        'Using the list of tone words you just generated, please translate my response into Spanish in those tones. Give your response as JSON in the format {"tone": tone, "translation": translation}, {"tone": tone, "translation": translation}, {"tone": tone, "translation": translation}. Be sure to separate each object with commas. Your response should start with a "{" and end with a "}".');
    response = await chat.sendMessage(content);
    return (response.text).toString();
  }

    Future<void> _speakSpanishSentence(String input) async {
    await flutterTts.setLanguage('es-ES'); // Set language to Spanish (Spain)
    await flutterTts.setPitch(1.0); // Set pitch (optional)
    await flutterTts.setSpeechRate(1.0); // Set speech rate (optional)
    await flutterTts.speak(input); // Spanish sentence to speak
  }

  // List<String> parseThree(String input) {
  //   List<String> result = [];
  //   List<String> lines = input.split('\n');

  //   for (int i = 0; i < lines.length; i++) {
  //     List<String> parts = lines[i].split(':');
  //     result.add(
  //         parts[0].trim().replaceAll('*', '')); // Add the word in asterisks

  //     if (parts.length > 1) {
  //       result.add(parts[1].trim()); // Add the rest of the sentence
  //     } else {
  //       if (i + 1 < lines.length) {
  //         result.add(
  //             lines[i + 1].trim()); // If there's no colon, add the next line
  //       }
  //     }
  //   }
  //   return result;
  // }

  @override
  void initState() {
    super.initState();
    _initModel();
    getResAndParse();
  }

  void getResAndParse() async {
    _displayedText = widget.lastWords;
    _textInput = widget.textInput;

    print("pre everything");
    print(_displayedText);
    print(_textInput);
    String res = await getresponse(_displayedText, _chat, _textInput);
    print(res);
    print("in getResAndParse");

    // List<String> result = [];
    // final regexp = RegExp('r\{([^}]+)\}');
    // final matches = regexp.allMatches(res);
    // for (Match match in matches) {
    //   String json = match.group(1) ?? 'BEANS';
    //   print(json);
    //   result.add(json);
    // }

    // print(result);
    // for (String json in result) {
    //   final parsedJson = jsonDecode(json);
    //   trans.add(parsedJson['tone']);
    //   tones.add(parsedJson['translation']);
    // }

    List<Map<String, String>> listOfMaps = extractToneAndTranslation(res);

    Map<String, String> first = listOfMaps[0];
    Map<String, String> sec = listOfMaps[1];
    Map<String, String> third = listOfMaps[2];

    setState(() {
      response1 = first.values.elementAt(1);
      response2 = sec.values.elementAt(1);
      response3 = third.values.elementAt(1);

      tone1 = first.values.elementAt(0);
      tone2 = sec.values.elementAt(0);
      tone3 = third.values.elementAt(0);
    });
    String t1 = '', t2 = '', t3 = '';
    try {
      t1 = await TranslationService.translate(response1);
      t2 = await TranslationService.translate(response2);
      t3 = await TranslationService.translate(response3);
    } catch (e) {
      final englishTranslation = "translation failed :(";
    }

    setState(() {
      eng1 = t1;
      eng2 = t2;
      eng3 = t3;
    });    
  }

  List<Map<String, String>> extractToneAndTranslation(String input) {
    List<Map<String, String>> result = [];
    List<String> elements = input.split(RegExp(r'},\s*{'));

    for (var element in elements) {
      if (!element.startsWith('{')) {
        element = '{' + element;
      }
      if (!element.endsWith('}')) {
        element = element + '}';
      }
      Map<String, dynamic> obj = jsonDecode(element);
      result.add({
        'tone': obj['tone'],
        'translation': obj['translation'],
      });
    }

    return result;
  }

  void _initModel() {
    const apiKey = bool.hasEnvironment('API_KEY')
        ? String.fromEnvironment('API_KEY', defaultValue: 'NO_KEY')
        : null;
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }
    _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: apiKey,
        generationConfig: GenerationConfig(maxOutputTokens: 200));

    _chat = _model.startChat(history: [
      Content.text(
          'Hello, I am going to have a conversation with a friend who is around my age in Spanish. You are going to receive a transcription as the conversation goes and help me communicate with this stranger. Please include no additional comments in your replies.'),
      Content.model([TextPart('Great to meet you.')])
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              _displayedText,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Change button color to red
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              ),
              child: Text(
                'Speak Again',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 300),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Do something when Placeholder1 button is pressed
                      _speakSpanishSentence(response1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    ),
                    child: Text(
                      response1,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                    child: Text(
                      eng1, // Output text for response 1
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Do something when Placeholder2 button is pressed
                      _speakSpanishSentence(response2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    ),
                    child: Text(
                      response2,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                    child: Text(
                      eng2, // Output text for response 2
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Do something when Placeholder3 button is pressed
                      _speakSpanishSentence(response3);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    ),
                    child: Text(
                      response3,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                    child: Text(
                      eng3, // Output text for response 3
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
