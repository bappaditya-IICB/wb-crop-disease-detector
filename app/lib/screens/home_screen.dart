import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/app_state.dart';
import '../services/tflite_service.dart';
import '../widgets/crop_card.dart';
import 'scan_result_screen.dart';
import 'language_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _picker = ImagePicker();
  bool _isAnalyzing = false;

  Future<void> _pickAndAnalyze(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 92,
    );
    if (picked == null) return;

    setState(() => _isAnalyzing = true);

    try {
      final tflite = context.read<TFLiteService>();
      if (!tflite.isLoaded) await tflite.loadModel();

      final result = await tflite.predict(File(picked.path));

      if (!mounted) return;
      setState(() => _isAnalyzing = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScanResultScreen(result: result),
        ),
      );
    } catch (e) {
      setState(() => _isAnalyzing = false);
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.errorTitle),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.errorRetry),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l        = AppLocalizations.of(context);
    final theme    = Theme.of(context);
    final cs       = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background decoration ──────────────────────────────────────
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.secondary.withOpacity(0.06),
              ),
            ),
          ),

          // ── Main scroll content ────────────────────────────────────────
          SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context, l, cs),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 8),
                      _buildGreeting(l, cs),
                      const SizedBox(height: 32),
                      _buildTipCard(l, cs),
                      const SizedBox(height: 32),
                      _buildScanButtons(l, cs),
                      const SizedBox(height: 40),
                      _buildCropsSection(l, cs),
                      const SizedBox(height: 80),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // ── Analyzing overlay ──────────────────────────────────────────
          if (_isAnalyzing) _buildAnalyzingOverlay(l, cs),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l, ColorScheme cs) {
    return SliverAppBar(
      pinned: false,
      floating: true,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('🌾', style: TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 10),
          Text(l.appTitle,
            style: TextStyle(
              fontFamily: 'Hind',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: cs.primary,
            )),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.language_rounded),
          tooltip: l.languageButton,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LanguageScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting(AppLocalizations l, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.homeGreeting,
          style: const TextStyle(
            fontFamily: 'Hind',
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ).animate().fadeIn().slideX(begin: -0.2),
        const SizedBox(height: 8),
        Text(l.homeSubtitle,
          style: TextStyle(
            fontSize: 15,
            color: cs.onBackground.withOpacity(0.6),
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 150.ms),
      ],
    );
  }

  Widget _buildTipCard(AppLocalizations l, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.secondary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('💡', style: TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.tip,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: cs.primary,
                  )),
                const SizedBox(height: 2),
                Text(l.tipText,
                  style: const TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildScanButtons(AppLocalizations l, ColorScheme cs) {
    return Column(
      children: [
        // Camera button (primary, large)
        Material(
          color: cs.primary,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _pickAndAnalyze(ImageSource.camera),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                      color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(l.scanButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      )),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white54, size: 16),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

        const SizedBox(height: 12),

        // Gallery button (secondary)
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _pickAndAnalyze(ImageSource.gallery),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              decoration: BoxDecoration(
                border: Border.all(color: cs.primary.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.photo_library_rounded,
                      color: cs.primary, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(l.galleryButton,
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                    color: cs.primary.withOpacity(0.4), size: 16),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildCropsSection(AppLocalizations l, ColorScheme cs) {
    final crops = [
      (emoji: '🌾', label: l.homeRiceCard,   color: const Color(0xFF558B2F)),
      (emoji: '🌿', label: l.homeWheatCard,  color: const Color(0xFFF57F17)),
      (emoji: '🌽', label: l.homeCornCard,   color: const Color(0xFFE65100)),
      (emoji: '🥔', label: l.homePotatoCard, color: const Color(0xFF4527A0)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Supported Crops',
          style: TextStyle(
            fontFamily: 'Hind',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.onBackground,
          )),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: crops.asMap().entries.map((e) {
            final c = e.value;
            return CropCard(
              emoji: c.emoji,
              label: c.label,
              color: c.color,
              delay: Duration(milliseconds: 600 + e.key * 100),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnalyzingOverlay(AppLocalizations l, ColorScheme cs) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔬', style: TextStyle(fontSize: 56))
                  .animate(onPlay: (c) => c.repeat())
                  .scaleXY(begin: 0.9, end: 1.1, duration: 800.ms)
                  .then()
                  .scaleXY(begin: 1.1, end: 0.9, duration: 800.ms),
              const SizedBox(height: 20),
              Text(l.analyzing,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                )),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                backgroundColor: cs.primary.withOpacity(0.1),
                color: cs.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
