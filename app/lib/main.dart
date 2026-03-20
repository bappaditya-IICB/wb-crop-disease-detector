import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'services/app_state.dart';
import 'services/tflite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        Provider(create: (_) => TFLiteService()),
      ],
      child: const KrishakAIApp(),
    ),
  );
}

class KrishakAIApp extends StatelessWidget {
  const KrishakAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp(
      title: 'KrishakAI – ফসলের রোগ নির্ণয়',
      debugShowCheckedModeBanner: false,

      // ── Localisation ──────────────────────────────────────────────────────
      locale: appState.locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('bn'), // Bengali
        Locale('hi'), // Hindi
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── Theme ─────────────────────────────────────────────────────────────
      theme: _buildTheme(),

      home: const SplashScreen(),
    );
  }

  ThemeData _buildTheme() {
    const Color primaryGreen    = Color(0xFF2E7D32);
    const Color lightGreen      = Color(0xFF66BB6A);
    const Color accentAmber     = Color(0xFFF9A825);
    const Color bgCream         = Color(0xFFF8F5F0);
    const Color cardWhite       = Color(0xFFFFFFFF);
    const Color textDark        = Color(0xFF1A1A1A);
    const Color textMedium      = Color(0xFF4A4A4A);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        primary:    primaryGreen,
        secondary:  lightGreen,
        tertiary:   accentAmber,
        surface:    cardWhite,
        background: bgCream,
        onPrimary:  Colors.white,
        onSecondary: Colors.white,
        onBackground: textDark,
      ),

      scaffoldBackgroundColor: bgCream,

      textTheme: GoogleFonts.hindTextTheme().copyWith(
        displayLarge:  const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: textDark),
        displayMedium: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: textDark),
        titleLarge:    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
        titleMedium:   const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textDark),
        bodyLarge:     const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textMedium),
        bodyMedium:    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textMedium),
        labelLarge:    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),

      cardTheme: CardTheme(
        color: cardWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          fontFamily: 'Hind',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
      ),
    );
  }
}
