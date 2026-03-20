import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CropCard extends StatelessWidget {
  final String emoji;
  final String label;
  final Color  color;
  final Duration delay;

  const CropCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.12),
            color.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 34)),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Hind',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: delay).scale(
          begin: const Offset(0.85, 0.85),
          delay: delay,
        );
  }
}
