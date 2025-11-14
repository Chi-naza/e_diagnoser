import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  final resultTextResponse = "".obs;
  final isLoading = false.obs;

  late FlutterTts _flutterTts;

  @override
  void onReady() {
    _flutterTts = FlutterTts();
    if (kDebugMode) print("FLUTTER TTS INITIALIZED - $_flutterTts");
    _initFlutterTTS();
    super.onReady();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> askQuestion({String? disease}) async {
    isLoading.value = true;

    disease ??= "Cassava Blight";

    Gemini.instance.prompt(parts: [
      Part.text('Causes, symptoms and solutions to $disease Disease'),
    ]).then((value) async {
      var output = value?.output;
      if (kDebugMode) print("FROM G-E-M-I-N-I  :::: $output");
      resultTextResponse.value = output ?? "";
      isLoading.value = false;
      // speak out the result

      if (resultTextResponse.value.isNotEmpty) {
        var generalText =
            (output ?? "").replaceAll(RegExp(r'[^a-zA-Z0-9\. ]'), '');
        int textLength = generalText.length;

        if (kDebugMode) print("TEXT LENGTH - $textLength");

        String textChunkOne = textLength < 3000
            ? generalText.substring(0, textLength)
            : generalText.substring(0, 3000);
        String textChunkTwo = textLength > 3000
            ? generalText.substring(3000)
            : "This is the end!";

        await startSpeaking(textChunkOne);
        if (kDebugMode) print(":::::::SECOND CHUNK STARTED:::::::");
        await startSpeaking(textChunkTwo);
      }
    });
  }

  Future<void> _initFlutterTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> startSpeaking(String textToSpeak) async {
    await _flutterTts.speak(textToSpeak);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }
}
