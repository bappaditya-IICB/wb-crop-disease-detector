import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, bengali, hindi }

class AppState extends ChangeNotifier {
  Locale _locale = const Locale('bn'); // Default: Bengali for West Bengal
  AppLanguage _language = AppLanguage.bengali;
  bool _onboardingDone = false;

  Locale get locale => _locale;
  AppLanguage get language => _language;
  bool get onboardingDone => _onboardingDone;

  AppState() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language') ?? 'bn';
    _onboardingDone = prefs.getBool('onboarding_done') ?? false;
    _setLocaleFromCode(langCode);
    notifyListeners();
  }

  void _setLocaleFromCode(String code) {
    switch (code) {
      case 'en':
        _locale = const Locale('en');
        _language = AppLanguage.english;
        break;
      case 'hi':
        _locale = const Locale('hi');
        _language = AppLanguage.hindi;
        break;
      default:
        _locale = const Locale('bn');
        _language = AppLanguage.bengali;
    }
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    switch (lang) {
      case AppLanguage.english:
        _locale = const Locale('en');
        break;
      case AppLanguage.bengali:
        _locale = const Locale('bn');
        break;
      case AppLanguage.hindi:
        _locale = const Locale('hi');
        break;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _locale.languageCode);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    notifyListeners();
  }
}
