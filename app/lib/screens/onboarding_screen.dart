import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../services/app_state.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';

class _OnboardPage {
  final String emoji;
  final Color  bgColor;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) desc;

  const _OnboardPage({
    required this.emoji,
    required this.bgColor,
    required this.title,
    required this.desc,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;
  bool _languageSelected = false;

  final _pages = <_OnboardPage>[
    _OnboardPage(
      emoji: '🔍',
      bgColor: const Color(0xFF1B5E20),
      title: (l) => l.onboardingTitle1,
      desc:  (l) => l.onboardingDesc1,
    ),
    _OnboardPage(
      emoji: '📵',
      bgColor: const Color(0xFF0277BD),
      title: (l) => l.onboardingTitle2,
      desc:  (l) => l.onboardingDesc2,
    ),
    _OnboardPage(
      emoji: '💊',
      bgColor: const Color(0xFF6A1B9A),
      title: (l) => l.onboardingTitle3,
      desc:  (l) => l.onboardingDesc3,
    ),
  ];

  void _next(AppLocalizations l, AppState appState) {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish(appState);
    }
  }

  void _finish(AppState appState) {
    appState.completeOnboarding();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l         = AppLocalizations.of(context);
    final appState  = context.watch<AppState>();
    final isLast    = _currentPage == _pages.length - 1;

    if (!_languageSelected) {
      return _LanguageSelectScreen(
        onSelected: () => setState(() => _languageSelected = true),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _buildPage(_pages[i], l),
          ),

          // Bottom controls
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: WormEffect(
                    dotWidth: 10,
                    dotHeight: 10,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _pages[_currentPage].bgColor,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => _next(l, appState),
                  child: Text(isLast ? l.getStarted : l.next),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardPage page, AppLocalizations l) {
    return Container(
      color: page.bgColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(page.emoji, style: const TextStyle(fontSize: 96))
                  .animate()
                  .scale(begin: const Offset(0.5, 0.5))
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 40),
              Text(
                page.title(l),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Hind',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ).animate().slideY(begin: 0.3).fadeIn(duration: 500.ms, delay: 200.ms),
              const SizedBox(height: 16),
              Text(
                page.desc(l),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.5,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
              const SizedBox(height: 120), // Space for bottom controls
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Language Selection Page
// ─────────────────────────────────────────────────────────────────────────────

class _LanguageSelectScreen extends StatelessWidget {
  final VoidCallback onSelected;
  const _LanguageSelectScreen({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🌐', style: TextStyle(fontSize: 72))
                    .animate()
                    .scale(begin: const Offset(0.5, 0.5))
                    .fadeIn(),

                const SizedBox(height: 24),

                const Text(
                  'Select Language\nভাষা নির্বাচন করুন\nभाषा चुनें',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 48),

                ...[
                  (_LangOption('বাংলা', 'Bengali', AppLanguage.bengali)),
                  (_LangOption('हिंदी', 'Hindi',   AppLanguage.hindi)),
                  (_LangOption('English', 'English', AppLanguage.english)),
                ].map(
                  (opt) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _LanguageTile(
                      primaryText:   opt.primary,
                      secondaryText: opt.secondary,
                      onTap: () {
                        appState.setLanguage(opt.lang);
                        onSelected();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangOption {
  final String primary, secondary;
  final AppLanguage lang;
  _LangOption(this.primary, this.secondary, this.lang);
}

class _LanguageTile extends StatelessWidget {
  final String primaryText, secondaryText;
  final VoidCallback onTap;
  const _LanguageTile({
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Row(
            children: [
              Text(primaryText,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                )),
              const SizedBox(width: 12),
              Text(secondaryText,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                )),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.2);
  }
}
