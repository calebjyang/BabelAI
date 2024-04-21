import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
  bool _isListening = false;
  late GenerativeModel _model;
  late ChatSession _chat;

  @override
  void initState() {
    super.initState();
    print('Initializing speech...');
    _initSpeech();
    _initModel();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    print('Initializing...');
    _speechEnabled = await _speechToText.initialize();
    print('Speech initialized: $_speechEnabled');
    setState(() {});
  }

  void _initModel() {
    const apiKey = bool.hasEnvironment('API_KEY') ? String.fromEnvironment('API_KEY', defaultValue: 'NO_KEY') : null;
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }
    _model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: apiKey,
    generationConfig: GenerationConfig(maxOutputTokens: 200));

    _chat = _model.startChat(history: [
        Content.text('Hello, I am going to have a conversation with a friend who is around my age in Spanish. You are going to receive a transcription as the conversation goes and help me communicate with this stranger. Please include no additional comments in your replies.'),
      Content.model([TextPart('Great to meet you.')])
    ]);
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
    setState(() {
      _isListening = false;
    });

    // Navigate to the new page
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResultPage(lastWords: _lastWords)),
    );
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      print('Recognized words: $_lastWords');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Demo'),
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
                  // If listening is active show the recognized words
                  !_isListening ? _lastWords : '',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        tooltip: _isListening ? 'Stop Listening' : 'Listen',
        child: Icon(_isListening ? Icons.mic : Icons.mic_off),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String lastWords;

  const ResultPage({Key? key, required this.lastWords}) : super(key: key);

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
              'Recognized words:',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Text(
                lastWords,
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
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
                    )
                  )
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    ),
                    child: Text(
                      'This is a placeholder button. It may contain longer text.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Do something when Placeholder2 button is pressed
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    ),
                    child: Text(
                      'This is a placeholder button. It may contain longer text.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Do something when Placeholder3 button is pressed
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    ),
                    child: Text(
                      'This is a placeholder button. It may contain longer text.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
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
