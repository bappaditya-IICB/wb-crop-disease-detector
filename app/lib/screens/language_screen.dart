import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/app_state.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l       = AppLocalizations.of(context);
    final appState = context.read<AppState>();
    final cs      = Theme.of(context).colorScheme;

    final options = [
      (lang: AppLanguage.bengali, native: 'বাংলা',   english: 'Bengali', flag: '🇧🇩'),
      (lang: AppLanguage.hindi,   native: 'हिंदी',    english: 'Hindi',   flag: '🇮🇳'),
      (lang: AppLanguage.english, native: 'English',  english: 'English', flag: '🌐'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l.selectLanguage),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.selectLanguage,
              style: const TextStyle(
                fontFamily: 'Hind',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 8),
            Text(
              'ভাষা নির্বাচন করুন / भाषा चुनें',
              style: TextStyle(
                fontSize: 14,
                color: cs.onBackground.withOpacity(0.5),
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 32),
            ...options.asMap().entries.map((e) {
              final opt      = e.value;
              final isCurrent = context.watch<AppState>().language == opt.lang;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _LanguageOption(
                  flag:       opt.flag,
                  native:     opt.native,
                  english:    opt.english,
                  isSelected: isCurrent,
                  onTap: () {
                    appState.setLanguage(opt.lang);
                    Navigator.pop(context);
                  },
                ).animate().fadeIn(delay: Duration(milliseconds: 200 + e.key * 100))
                  .slideX(begin: 0.2),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag, native, english;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.native,
    required this.english,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? cs.primary.withOpacity(0.08) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? cs.primary : Colors.grey.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(native,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? cs.primary : null,
                      )),
                    Text(english,
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onBackground.withOpacity(0.5),
                      )),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle_rounded, color: cs.primary, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
