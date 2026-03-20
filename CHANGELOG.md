# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- Jute disease classes (yellow mite, stem rot)
- Mustard disease classes (Alternaria blight, white rust)
- Voice output for low-literacy users
- Weather-based seasonal disease alerts

---

## [1.0.0] — 2024-XX-XX

### Added
- Initial public release
- **15 disease classes** across rice, wheat, corn, and potato
- **Bengali, Hindi, English** multilingual support (Bengali default)
- On-device MobileNetV2 TFLite model (FP16, ~8 MB)
- Camera capture and gallery upload
- Confidence score with colour-coded indicator
- Disease name, cause type, symptoms, treatment, prevention
- Top-3 alternative predictions
- Share results via WhatsApp/SMS
- 3-page onboarding flow with language selection
- 100% offline functionality
- Android 5.0+ (API 21) support

### Model
- Base: MobileNetV2 (ImageNet pre-trained)
- Training data: ~1,300 images from Kaggle dataset
- Test accuracy: ~85–92% (varies by training run)
- Inference time: ~150–400 ms on ARM64 CPU

---

[Unreleased]: https://github.com/YOUR_USERNAME/wb-crop-disease-detector/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/YOUR_USERNAME/wb-crop-disease-detector/releases/tag/v1.0.0
