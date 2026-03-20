import 'dart:async';
import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Manual localizations class (replaces flutter gen-l10n for offline builds)
// ──────────────────────────────────────────────────────────────────────────────

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // ── String map ──────────────────────────────────────────────────────────────
  static final Map<String, Map<String, String>> _strings = {
    'en': {
      'appTitle':             'KrishakAI',
      'appSubtitle':          'Crop Disease Detection',
      'homeGreeting':         'Jai Kisan! 🌾',
      'homeSubtitle':         'Take a photo of your crop leaf to detect diseases instantly.',
      'scanButton':           'Scan Crop Leaf',
      'galleryButton':        'Upload from Gallery',
      'historyButton':        'Scan History',
      'aboutButton':          'About',
      'languageButton':       'Language',
      'analyzing':            'Analyzing your crop…',
      'resultTitle':          'Detection Result',
      'diseaseLabel':         'Disease Detected',
      'healthyLabel':         'Healthy Crop! ✅',
      'confidence':           'Confidence',
      'symptoms':             'Symptoms',
      'cause':                'Cause',
      'treatment':            'Treatment',
      'prevention':           'Prevention',
      'causeType':            'Type',
      'severity':             'Severity',
      'cropType':             'Crop',
      'tryAgain':             'Scan Another',
      'shareResult':          'Share Result',
      'noHistory':            'No scans yet',
      'highSeverity':         'High',
      'mediumSeverity':       'Medium',
      'lowSeverity':          'Low',
      'fungal':               'Fungal Disease',
      'bacterial':            'Bacterial Disease',
      'viral':                'Viral Disease',
      'onboardingTitle1':     'Detect Crop Diseases',
      'onboardingDesc1':      'Point your camera at any crop leaf to instantly identify diseases.',
      'onboardingTitle2':     'Works Offline',
      'onboardingDesc2':      'No internet needed. AI works completely on your phone.',
      'onboardingTitle3':     'Get Treatment Advice',
      'onboardingDesc3':      'Get actionable, India-specific treatment recommendations.',
      'getStarted':           'Get Started',
      'next':                 'Next',
      'selectLanguage':       'Select Language',
      'english':              'English',
      'bengali':              'বাংলা',
      'hindi':                'हिंदी',
      'tip':                  'Tip',
      'tipText':              'For best results, take a clear photo of a single leaf in good lighting.',
      'loadingModel':         'Loading AI model…',
      'errorTitle':           'Oops!',
      'errorRetry':           'Try Again',
      'lowConfidenceWarning': 'Low confidence — try a clearer photo',
      'consultExpert':        'Consult your local agriculture officer if unsure.',
      'homeRiceCard':         'Rice',
      'homeWheatCard':        'Wheat',
      'homeCornCard':         'Corn',
      'homePotatoCard':       'Potato',
      'otherPossibilities':   'Other Possibilities',
      'noneDetected':         'None',
      'backToHome':           'Back to Home',
      'scanDate':             'Scanned on',
    },
    'bn': {
      'appTitle':             'কৃষকAI',
      'appSubtitle':          'ফসলের রোগ নির্ণয়',
      'homeGreeting':         'জয় কিষান! 🌾',
      'homeSubtitle':         'রোগ তাৎক্ষণিকভাবে শনাক্ত করতে ফসলের পাতার ছবি তুলুন।',
      'scanButton':           'ফসলের পাতা স্ক্যান করুন',
      'galleryButton':        'গ্যালারি থেকে আপলোড করুন',
      'historyButton':        'স্ক্যান ইতিহাস',
      'aboutButton':          'পরিচিতি',
      'languageButton':       'ভাষা',
      'analyzing':            'আপনার ফসল বিশ্লেষণ করা হচ্ছে…',
      'resultTitle':          'শনাক্তকরণের ফলাফল',
      'diseaseLabel':         'রোগ শনাক্ত হয়েছে',
      'healthyLabel':         'সুস্থ ফসল! ✅',
      'confidence':           'নিশ্চিততা',
      'symptoms':             'লক্ষণসমূহ',
      'cause':                'কারণ',
      'treatment':            'চিকিৎসা',
      'prevention':           'প্রতিরোধ',
      'causeType':            'ধরন',
      'severity':             'তীব্রতা',
      'cropType':             'ফসল',
      'tryAgain':             'আবার স্ক্যান করুন',
      'shareResult':          'ফলাফল শেয়ার করুন',
      'noHistory':            'এখনো কোনো স্ক্যান নেই',
      'highSeverity':         'উচ্চ',
      'mediumSeverity':       'মাঝারি',
      'lowSeverity':          'কম',
      'fungal':               'ছত্রাকজনিত রোগ',
      'bacterial':            'ব্যাকটেরিয়াজনিত রোগ',
      'viral':                'ভাইরাসজনিত রোগ',
      'onboardingTitle1':     'ফসলের রোগ শনাক্ত করুন',
      'onboardingDesc1':      'যেকোনো ফসলের পাতায় ক্যামেরা ধরুন এবং তাৎক্ষণিকভাবে রোগ শনাক্ত করুন।',
      'onboardingTitle2':     'ইন্টারনেট ছাড়া কাজ করে',
      'onboardingDesc2':      'ইন্টারনেটের প্রয়োজন নেই। AI সম্পূর্ণ ফোনে কাজ করে।',
      'onboardingTitle3':     'চিকিৎসার পরামর্শ পান',
      'onboardingDesc3':      'ভারত-নির্দিষ্ট কার্যকর চিকিৎসার সুপারিশ পান।',
      'getStarted':           'শুরু করুন',
      'next':                 'পরবর্তী',
      'selectLanguage':       'ভাষা নির্বাচন করুন',
      'english':              'English',
      'bengali':              'বাংলা',
      'hindi':                'हिंदी',
      'tip':                  'পরামর্শ',
      'tipText':              'সর্বোত্তম ফলাফলের জন্য, ভালো আলোতে একটি পাতার স্পষ্ট ছবি তুলুন।',
      'loadingModel':         'AI মডেল লোড হচ্ছে…',
      'errorTitle':           'ওহো!',
      'errorRetry':           'আবার চেষ্টা করুন',
      'lowConfidenceWarning': 'কম নিশ্চিততা — আরো স্পষ্ট ছবি তুলুন',
      'consultExpert':        'নিশ্চিত না হলে স্থানীয় কৃষি কর্মকর্তার সাথে যোগাযোগ করুন।',
      'homeRiceCard':         'ধান',
      'homeWheatCard':        'গম',
      'homeCornCard':         'ভুট্টা',
      'homePotatoCard':       'আলু',
      'otherPossibilities':   'অন্যান্য সম্ভাবনা',
      'noneDetected':         'কিছু না',
      'backToHome':           'হোমে ফিরুন',
      'scanDate':             'স্ক্যান করা হয়েছে',
    },
    'hi': {
      'appTitle':             'किसानAI',
      'appSubtitle':          'फसल रोग पहचान',
      'homeGreeting':         'जय किसान! 🌾',
      'homeSubtitle':         'बीमारी तुरंत पहचानने के लिए अपनी फसल की पत्ती की फोटो लें।',
      'scanButton':           'फसल की पत्ती स्कैन करें',
      'galleryButton':        'गैलरी से अपलोड करें',
      'historyButton':        'स्कैन इतिहास',
      'aboutButton':          'परिचय',
      'languageButton':       'भाषा',
      'analyzing':            'आपकी फसल का विश्लेषण हो रहा है…',
      'resultTitle':          'पहचान परिणाम',
      'diseaseLabel':         'रोग पहचाना गया',
      'healthyLabel':         'स्वस्थ फसल! ✅',
      'confidence':           'निश्चितता',
      'symptoms':             'लक्षण',
      'cause':                'कारण',
      'treatment':            'उपचार',
      'prevention':           'रोकथाम',
      'causeType':            'प्रकार',
      'severity':             'गंभीरता',
      'cropType':             'फसल',
      'tryAgain':             'फिर स्कैन करें',
      'shareResult':          'परिणाम साझा करें',
      'noHistory':            'अभी तक कोई स्कैन नहीं',
      'highSeverity':         'उच्च',
      'mediumSeverity':       'मध्यम',
      'lowSeverity':          'कम',
      'fungal':               'फफूंद रोग',
      'bacterial':            'जीवाणु रोग',
      'viral':                'वायरस रोग',
      'onboardingTitle1':     'फसल रोग पहचानें',
      'onboardingDesc1':      'किसी भी फसल की पत्ती पर कैमरा लक्ष्य करें और तुरंत रोग पहचानें।',
      'onboardingTitle2':     'ऑफलाइन काम करता है',
      'onboardingDesc2':      'इंटरनेट की जरूरत नहीं। AI पूरी तरह आपके फोन पर काम करता है।',
      'onboardingTitle3':     'उपचार सलाह पाएं',
      'onboardingDesc3':      'भारत-विशिष्ट क्रियाशील उपचार सिफारिशें प्राप्त करें।',
      'getStarted':           'शुरू करें',
      'next':                 'अगला',
      'selectLanguage':       'भाषा चुनें',
      'english':              'English',
      'bengali':              'বাংলা',
      'hindi':                'हिंदी',
      'tip':                  'सुझाव',
      'tipText':              'सर्वोत्तम परिणाम के लिए अच्छी रोशनी में एकल पत्ती की स्पष्ट फोटो लें।',
      'loadingModel':         'AI मॉडल लोड हो रहा है…',
      'errorTitle':           'ओह!',
      'errorRetry':           'फिर प्रयास करें',
      'lowConfidenceWarning': 'कम निश्चितता — अधिक स्पष्ट फोटो लें',
      'consultExpert':        'अनिश्चित होने पर स्थानीय कृषि अधिकारी से परामर्श लें।',
      'homeRiceCard':         'धान',
      'homeWheatCard':        'गेहूं',
      'homeCornCard':         'मक्का',
      'homePotatoCard':       'आलू',
      'otherPossibilities':   'अन्य संभावनाएं',
      'noneDetected':         'कोई नहीं',
      'backToHome':           'होम पर वापस जाएं',
      'scanDate':             'स्कैन किया गया',
    },
  };

  String t(String key) {
    final lang = locale.languageCode;
    return _strings[lang]?[key] ?? _strings['en']?[key] ?? key;
  }

  // Convenience getters
  String get appTitle           => t('appTitle');
  String get appSubtitle        => t('appSubtitle');
  String get homeGreeting       => t('homeGreeting');
  String get homeSubtitle       => t('homeSubtitle');
  String get scanButton         => t('scanButton');
  String get galleryButton      => t('galleryButton');
  String get historyButton      => t('historyButton');
  String get aboutButton        => t('aboutButton');
  String get languageButton     => t('languageButton');
  String get analyzing          => t('analyzing');
  String get resultTitle        => t('resultTitle');
  String get diseaseLabel       => t('diseaseLabel');
  String get healthyLabel       => t('healthyLabel');
  String get confidence         => t('confidence');
  String get symptoms           => t('symptoms');
  String get cause              => t('cause');
  String get treatment          => t('treatment');
  String get prevention         => t('prevention');
  String get causeType          => t('causeType');
  String get severity           => t('severity');
  String get cropType           => t('cropType');
  String get tryAgain           => t('tryAgain');
  String get shareResult        => t('shareResult');
  String get noHistory          => t('noHistory');
  String get highSeverity       => t('highSeverity');
  String get mediumSeverity     => t('mediumSeverity');
  String get lowSeverity        => t('lowSeverity');
  String get fungal             => t('fungal');
  String get bacterial          => t('bacterial');
  String get viral              => t('viral');
  String get onboardingTitle1   => t('onboardingTitle1');
  String get onboardingDesc1    => t('onboardingDesc1');
  String get onboardingTitle2   => t('onboardingTitle2');
  String get onboardingDesc2    => t('onboardingDesc2');
  String get onboardingTitle3   => t('onboardingTitle3');
  String get onboardingDesc3    => t('onboardingDesc3');
  String get getStarted         => t('getStarted');
  String get next               => t('next');
  String get selectLanguage     => t('selectLanguage');
  String get english            => t('english');
  String get bengali            => t('bengali');
  String get hindi              => t('hindi');
  String get tip                => t('tip');
  String get tipText            => t('tipText');
  String get loadingModel       => t('loadingModel');
  String get errorTitle         => t('errorTitle');
  String get errorRetry         => t('errorRetry');
  String get lowConfidenceWarning => t('lowConfidenceWarning');
  String get consultExpert      => t('consultExpert');
  String get homeRiceCard       => t('homeRiceCard');
  String get homeWheatCard      => t('homeWheatCard');
  String get homeCornCard       => t('homeCornCard');
  String get homePotatoCard     => t('homePotatoCard');
  String get otherPossibilities => t('otherPossibilities');
  String get backToHome         => t('backToHome');
  String get scanDate           => t('scanDate');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'bn', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
