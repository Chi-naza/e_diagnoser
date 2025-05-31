import 'dart:io';
import 'package:e_diagnoser/widgets/text_n_value_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class CaptureMainScreen extends StatefulWidget {
  const CaptureMainScreen({super.key});

  @override
  State<CaptureMainScreen> createState() => _CaptureMainScreenState();
}

class _CaptureMainScreenState extends State<CaptureMainScreen> {
  File? _image;
  late ImagePicker imagePicker;

  late ImageLabeler imageLabeler;

  String resultName = "";
  String resultConfidence = "0.0";

  @override
  void initState() {
    // init image picker
    imagePicker = ImagePicker();
    // init image labeler and load model
    loadModelFromAsset();
    // call super
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(
          "Enigma App Expresso",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 43),
              _image == null
                  ? Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/noimage.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
                        const TextAndValueWidget(
                          title: 'Image',
                          value: "No Image Details To Display",
                        ),
                        const SizedBox(height: 13),
                      ],
                    ),
                  )
                  : Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          // child: Image.file(_image!),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextAndValueWidget(
                              title: 'Name',
                              value: resultName,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                            ),
                            TextAndValueWidget(
                              title: 'Accuracy',
                              value: "%${double.parse(resultConfidence) * 100}",
                              textColor: Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextAndValueWidget(
                          title: 'Image',
                          value: _image!.path,
                          textColor: Colors.black38,
                        ),
                        const SizedBox(height: 13),
                      ],
                    ),
                  ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: pickAnImage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Text('Choose An Image From Gallery'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => pickAnImage(fromCamera: true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Text('Use The Camera Instead'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // pick image func
  Future<void> pickAnImage({bool fromCamera = false}) async {
    XFile? image;

    if (fromCamera) {
      image = await imagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await imagePicker.pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      setState(() {
        _image = File(image!.path);
      });
      doImageLabeling(_image!);
    }
  }

  // do image labelling
  Future<void> doImageLabeling(File image) async {
    final InputImage inputImage = InputImage.fromFile(image);

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;

      setState(() {
        resultName = text;
        resultConfidence = confidence.toStringAsFixed(2);
      });

      if (kDebugMode) {
        print(
          "(NAME: $text, Confidence: ${confidence.toStringAsFixed(1)}, INDEX: $index)",
        );
      }
    }
  }

  // find model path
  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
    }
    return file.path;
  }

  // initialize and load our custom model
  Future<void> loadModelFromAsset() async {
    final modelPath = await getModelPath(
      'assets/ml/fruits_model_metadata.tflite',
    );
    final options = LocalLabelerOptions(modelPath: modelPath);

    imageLabeler = ImageLabeler(options: options);
  }
}
