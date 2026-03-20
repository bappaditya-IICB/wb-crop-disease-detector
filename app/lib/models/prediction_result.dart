import 'dart:io';
import 'disease_info.dart';

class TopPrediction {
  final String      label;
  final double      confidence;
  final DiseaseInfo diseaseInfo;

  const TopPrediction({
    required this.label,
    required this.confidence,
    required this.diseaseInfo,
  });

  String get confidencePercent => '${(confidence * 100).toStringAsFixed(1)}%';

  bool get isHighConfidence => confidence >= 0.75;
  bool get isMediumConfidence => confidence >= 0.50 && confidence < 0.75;
  bool get isLowConfidence => confidence < 0.50;
}

class PredictionResult {
  final List<TopPrediction> topPredictions;
  final File     imageFile;
  final DateTime timestamp;

  const PredictionResult({
    required this.topPredictions,
    required this.imageFile,
    required this.timestamp,
  });

  TopPrediction get best => topPredictions.first;

  bool get hasResult => topPredictions.isNotEmpty;
}
