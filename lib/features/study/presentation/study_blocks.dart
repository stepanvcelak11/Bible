import 'package:flutter/material.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';

/// Nadpis oddílu studijního textu (barevný, verzálkami).
class StudyHeading extends StatelessWidget {
  const StudyHeading(this.text, {super.key, required this.color, this.icon});

  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Odstavce výkladu.
class StudyParagraphs extends StatelessWidget {
  const StudyParagraphs(this.paragraphs, {super.key});

  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.55);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final p in paragraphs)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(p, style: style),
          ),
      ],
    );
  }
}

/// Karta „Věděli jste?“ se zajímavostmi.
class FactsCard extends StatelessWidget {
  const FactsCard({super.key, required this.facts, required this.color});

  final List<String> facts;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: palette.gold.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: palette.gold, size: 20),
              const SizedBox(width: 8),
              Text(
                S.didYouKnow,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: palette.gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final f in facts)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 10),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: palette.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      f,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Očíslované otázky k zamyšlení.
class QuestionsBlock extends StatelessWidget {
  const QuestionsBlock({
    super.key,
    required this.questions,
    required this.color,
  });

  final List<String> questions;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        for (final (i, q) in questions.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: color.withValues(alpha: 0.16),
                  child: Text(
                    '${i + 1}',
                    style: theme.textTheme.labelLarge?.copyWith(color: color),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      q,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Zvýrazněná myšlenka „Pro život“.
class LifeCard extends StatelessWidget {
  const LifeCard({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.directions_walk, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.forLifeStep,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Barevná hlavička detailu (téma, postava, kniha, situace): štítek,
/// velký název, podtitul a decentní velká ikona v pozadí.
class StudyHero extends StatelessWidget {
  const StudyHero({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    this.kicker,
    this.subtitle,
    this.monogram,
    this.footer,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String? kicker;
  final String? subtitle;

  /// Místo ikony v rámečku písmena (např. zkratka knihy).
  final String? monogram;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const onColor = Colors.white;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(color, Colors.white, 0.05)!,
            Color.lerp(color, Colors.black, 0.38)!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -20,
            child: Icon(
              icon,
              size: 140,
              color: Colors.white.withValues(alpha: 0.09),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: monogram != null
                          ? Text(
                              monogram!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: onColor,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          : Icon(icon, color: onColor),
                    ),
                    if (kicker != null) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          kicker!.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: onColor.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: onColor,
                    height: 1.15,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: onColor.withValues(alpha: 0.92),
                      height: 1.45,
                    ),
                  ),
                ],
                if (footer != null) ...[const SizedBox(height: 14), footer!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Karta s údaji (ikona, popisek, hodnota) pod sebou.
class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.rows, required this.color});

  final List<(IconData, String, String)> rows;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final shown = [
      for (final r in rows)
        if (r.$3.trim().isNotEmpty) r,
    ];
    if (shown.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            for (final (i, (icon, label, value)) in shown.indexed) ...[
              if (i > 0) const Divider(height: 1, indent: 52),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 20, color: color),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: palette.muted,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            value,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
