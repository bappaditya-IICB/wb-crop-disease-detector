import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/prediction_result.dart';
import '../models/disease_info.dart';
import '../widgets/info_section.dart';

class ScanResultScreen extends StatelessWidget {
  final PredictionResult result;
  const ScanResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final l    = AppLocalizations.of(context);
    final best = result.best;
    final info = best.diseaseInfo;
    final lang = Localizations.localeOf(context).languageCode;
    final cs   = Theme.of(context).colorScheme;

    final isHealthy   = info.isHealthy;
    final headerColor = isHealthy
        ? const Color(0xFF2E7D32)
        : _severityColor(info.severity);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero header ─────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: headerColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                onPressed: () => _shareResult(l, info, lang, best),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(l, best, info, lang, headerColor, cs),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Low confidence warning
                if (best.isLowConfidence)
                  _buildWarningBanner(l, cs),

                _buildMetaRow(l, info, lang, cs),
                const SizedBox(height: 20),

                // ── Confidence bar ─────────────────────────────────────
                _buildConfidenceSection(l, best, cs),
                const SizedBox(height: 8),

                // ── Symptoms ─────────────────────────────────────────
                InfoSection(
                  icon: '🔍',
                  title: l.symptoms,
                  body: info.symptoms[lang] ?? info.symptoms['en'] ?? '',
                  color: const Color(0xFF1565C0),
                ),

                // ── Cause ─────────────────────────────────────────────
                if (!isHealthy)
                  InfoSection(
                    icon: '🦠',
                    title: l.cause,
                    body: info.cause[lang] ?? info.cause['en'] ?? '',
                    color: const Color(0xFFB71C1C),
                  ),

                // ── Treatment ─────────────────────────────────────────
                InfoSection(
                  icon: '💊',
                  title: l.treatment,
                  body: info.treatment[lang] ?? info.treatment['en'] ?? '',
                  color: const Color(0xFF1B5E20),
                  highlight: true,
                ),

                // ── Prevention ───────────────────────────────────────
                InfoSection(
                  icon: '🛡️',
                  title: l.prevention,
                  body: info.prevention[lang] ?? info.prevention['en'] ?? '',
                  color: const Color(0xFF4527A0),
                ),

                // ── Other possibilities ───────────────────────────────
                if (result.topPredictions.length > 1)
                  _buildOtherPossibilities(l, lang, cs),

                const SizedBox(height: 12),

                // ── Consult note ──────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF9A825).withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Text('ℹ️', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(l.consultExpert,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF5D4037),
                          )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Try again button ──────────────────────────────────
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: Text(l.tryAgain),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    AppLocalizations l,
    TopPrediction best,
    DiseaseInfo info,
    String lang,
    Color headerColor,
    ColorScheme cs,
  ) {
    final displayName = info.displayName[lang] ?? info.displayName['en'] ?? '';
    final isHealthy   = info.isHealthy;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [headerColor, headerColor.withOpacity(0.8)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    isHealthy ? '✅' : '⚠️',
                    style: const TextStyle(fontSize: 36),
                  ).animate().scale(begin: const Offset(0.5, 0.5)).fadeIn(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        fontFamily: 'Hind',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isHealthy ? l.healthyLabel : l.diseaseLabel,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ).animate().fadeIn(delay: 350.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow(
      AppLocalizations l, DiseaseInfo info, String lang, ColorScheme cs) {
    return Row(
      children: [
        if (!info.isHealthy) ...[
          _MetaChip(
            label: _causeLabel(l, info.causeType),
            icon: _causeIcon(info.causeType),
            color: const Color(0xFFB71C1C),
          ),
          const SizedBox(width: 8),
          _MetaChip(
            label: _severityLabel(l, info.severity),
            icon: '⚡',
            color: _severityColor(info.severity),
          ),
          const SizedBox(width: 8),
        ],
        _MetaChip(
          label: info.cropType.toUpperCase(),
          icon: _cropIcon(info.cropType),
          color: cs.primary,
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildConfidenceSection(
      AppLocalizations l, TopPrediction best, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l.confidence,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text(
              best.confidencePercent,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _confidenceColor(best.confidence),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          percent: best.confidence.clamp(0.0, 1.0),
          lineHeight: 12,
          animation: true,
          animationDuration: 1000,
          backgroundColor: cs.primary.withOpacity(0.1),
          linearGradient: LinearGradient(
            colors: [
              _confidenceColor(best.confidence).withOpacity(0.7),
              _confidenceColor(best.confidence),
            ],
          ),
          barRadius: const Radius.circular(8),
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildWarningBanner(AppLocalizations l, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFA000)),
      ),
      child: Row(
        children: [
          const Text('⚠️'),
          const SizedBox(width: 8),
          Expanded(
            child: Text(l.lowConfidenceWarning,
              style: const TextStyle(fontSize: 13, color: Color(0xFFE65100))),
          ),
        ],
      ),
    ).animate().fadeIn().shake();
  }

  Widget _buildOtherPossibilities(
      AppLocalizations l, String lang, ColorScheme cs) {
    final others = result.topPredictions.skip(1).toList();
    if (others.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(l.otherPossibilities,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
        const SizedBox(height: 12),
        ...others.map((p) {
          final name = p.diseaseInfo.displayName[lang] ??
              p.diseaseInfo.displayName['en'] ?? p.label;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(name,
                    style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 8),
                Text(
                  p.confidencePercent,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: cs.primary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  void _shareResult(AppLocalizations l, DiseaseInfo info, String lang, TopPrediction best) {
    final name      = info.displayName[lang] ?? info.displayName['en'] ?? '';
    final treatment = info.treatment[lang] ?? info.treatment['en'] ?? '';
    final date      = DateFormat('dd MMM yyyy').format(result.timestamp);

    Share.share(
      '🌾 KrishakAI Disease Report\n'
      '📅 $date\n\n'
      '🔍 Detected: $name\n'
      '📊 Confidence: ${best.confidencePercent}\n\n'
      '💊 Treatment:\n$treatment\n\n'
      '─ KrishakAI – ফসলের রোগ নির্ণয়',
    );
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'high':   return const Color(0xFFB71C1C);
      case 'medium': return const Color(0xFFE65100);
      case 'low':    return const Color(0xFF558B2F);
      default:       return const Color(0xFF2E7D32);
    }
  }

  Color _confidenceColor(double c) {
    if (c >= 0.75) return const Color(0xFF2E7D32);
    if (c >= 0.50) return const Color(0xFFF57F17);
    return const Color(0xFFB71C1C);
  }

  String _causeLabel(AppLocalizations l, String type) {
    switch (type) {
      case 'fungal':    return l.fungal;
      case 'bacterial': return l.bacterial;
      case 'viral':     return l.viral;
      default:          return type;
    }
  }

  String _causeIcon(String type) {
    switch (type) {
      case 'fungal':    return '🍄';
      case 'bacterial': return '🦠';
      case 'viral':     return '🧬';
      default:          return '❓';
    }
  }

  String _cropIcon(String crop) {
    switch (crop) {
      case 'rice':   return '🌾';
      case 'wheat':  return '🌿';
      case 'corn':   return '🌽';
      case 'potato': return '🥔';
      default:       return '🌱';
    }
  }

  String _severityLabel(AppLocalizations l, String s) {
    switch (s) {
      case 'high':   return l.highSeverity;
      case 'medium': return l.mediumSeverity;
      case 'low':    return l.lowSeverity;
      default:       return s;
    }
  }
}

class _MetaChip extends StatelessWidget {
  final String label, icon;
  final Color  color;
  const _MetaChip({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            )),
        ],
      ),
    );
  }
}
