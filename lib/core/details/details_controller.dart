import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  final resultTextResponse = "".obs;
  final isLoading = false.obs;

  Future<void> askQuestion({String? disease}) async {
    isLoading.value = true;

    disease ??= "Cassava Blight";

    Gemini.instance.prompt(parts: [
      Part.text('Causes, symptoms and solutions to $disease Disease'),
    ]).then((value) {
      var output = value?.output;
      if (kDebugMode) print("FROM G-E-M-I-N-I  :::: $output");
      resultTextResponse.value = output ?? "";
      isLoading.value = false;
    });
  }
}
