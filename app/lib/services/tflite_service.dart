import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:logger/logger.dart';
import '../models/disease_info.dart';
import '../models/prediction_result.dart';

class TFLiteService {
  static const String _modelAsset  = 'assets/model/model.tflite';
  static const String _labelsAsset = 'assets/model/labels.txt';
  static const int    _inputSize   = 224;
  static const int    _topK        = 3;

  Interpreter?   _interpreter;
  List<String>   _labels = [];
  bool           _isLoaded = false;
  final Logger   _log = Logger();

  bool get isLoaded => _isLoaded;

  // ──────────────────────────────────────────────────────────────────────────
  // Initialization
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> loadModel() async {
    if (_isLoaded) return;
    try {
      _interpreter = await Interpreter.fromAsset(
        _modelAsset,
        options: InterpreterOptions()..threads = 4,
      );
      await _loadLabels();
      _isLoaded = true;
      _log.i('TFLite model loaded. Classes: ${_labels.length}');
    } catch (e) {
      _log.e('Model load error: $e');
      rethrow;
    }
  }

  Future<void> _loadLabels() async {
    final raw = await rootBundle.loadString(_labelsAsset);
    _labels = raw.trim().split('\n').map((l) => l.trim()).toList();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Pre-process image → Float32 tensor [1, 224, 224, 3]
  // ──────────────────────────────────────────────────────────────────────────
  Float32List _preprocess(File imageFile) {
    final bytes   = imageFile.readAsBytesSync();
    img.Image? src = img.decodeImage(bytes);
    if (src == null) throw Exception('Could not decode image');

    final resized = img.copyResize(src, width: _inputSize, height: _inputSize);

    final buffer = Float32List(_inputSize * _inputSize * 3);
    int idx = 0;
    for (int y = 0; y < _inputSize; y++) {
      for (int x = 0; x < _inputSize; x++) {
        final pixel = resized.getPixel(x, y);
        // MobileNetV2 preprocess: scale to [-1, 1]
        buffer[idx++] = (pixel.rNormalized * 2.0) - 1.0;
        buffer[idx++] = (pixel.gNormalized * 2.0) - 1.0;
        buffer[idx++] = (pixel.bNormalized * 2.0) - 1.0;
      }
    }
    return buffer;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Run inference
  // ──────────────────────────────────────────────────────────────────────────
  Future<PredictionResult> predict(File imageFile) async {
    if (!_isLoaded) await loadModel();

    final inputData = _preprocess(imageFile);
    final inputTensor = inputData.reshape([1, _inputSize, _inputSize, 3]);
    final outputTensor = List.filled(
      1 * _labels.length, 0.0,
    ).reshape([1, _labels.length]);

    _interpreter!.run(inputTensor, outputTensor);

    final probabilities = List<double>.from(
      (outputTensor as List)[0] as List,
    );

    // Sort to get top-K results
    final indexed = probabilities.asMap().entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topResults = indexed.take(_topK).map((e) {
      final label = e.key < _labels.length ? _labels[e.key] : 'Unknown';
      return TopPrediction(
        label: label,
        confidence: e.value,
        diseaseInfo: DiseaseDatabase.getInfo(label),
      );
    }).toList();

    return PredictionResult(
      topPredictions: topResults,
      imageFile: imageFile,
      timestamp: DateTime.now(),
    );
  }

  void dispose() {
    _interpreter?.close();
    _isLoaded = false;
  }
}
