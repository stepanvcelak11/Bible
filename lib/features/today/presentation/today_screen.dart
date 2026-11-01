import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/install/install_banner.dart';
import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/citation.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/today_providers.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/situations_screen.dart';
import '../../guide/presentation/guide_screen.dart';
import 'day_scene.dart';
import 'for_today.dart';
import 'my_reading_card.dart';

const _months = [
  'ledna', 'února', 'března', 'dubna', 'května', 'června', //
  'července', 'srpna', 'září', 'října', 'listopadu', 'prosince',
];
const _weekdays = [
  'pondělí',
  'úterý',
  'středa',
  'čtvrtek',
  'pátek',
  'sobota',
  'neděle',
];

/// Úvodní obrazovka „Dnes“.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final greeting = now.hour < 10
        ? S.goodMorning
        : now.hour < 18
        ? S.goodDay
        : S.goodEvening;
    final theme = Theme.of(context);
    final insets = MediaQuery.paddingOf(context);

    final time = dayTimeOf(now);
    final darkScene = theme.brightness == Brightness.dark;
    // Na obrázku: v noci a za soumraku světlý text, jinak tmavý.
    final onScene = time == DayTime.night || time == DayTime.dusk || darkScene
        ? Colors.white
        : const Color(0xFF2A2018);
    final heroHeight = insets.top + 270;
    // Tablet na šířku: dva sloupce pod obrázkem dne.
    final twoColumns = MediaQuery.sizeOf(context).width >= 1100;
    const gutter = 24.0;

    const reading = [
      InstallBanner(padding: EdgeInsets.only(top: 16)),
      SectionLabel(S.myReading),
      MyReadingCard(),
    ];
    const more = [_SituationsStrip(), ForTodaySection()];

    final compact = isCompactHeight(context);
    final settingsButton = IconButton(
      tooltip: S.settings,
      onPressed: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen())),
      icon: const Icon(Icons.tune),
    );

    return ListView(
      padding: EdgeInsets.only(bottom: insets.bottom + 110),
      children: [
        // Malý panel (rozdělená obrazovka na telefonu): bez obrázku dne.
        if (compact)
          Padding(
            padding: EdgeInsets.fromLTRB(20, insets.top + 4, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(greeting, style: theme.textTheme.titleLarge),
                ),
                settingsButton,
              ],
            ),
          ),
        if (compact)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _VerseOfDayCard(),
          )
        else
          Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: heroHeight,
                // Spodní okraj obrázku se rozplyne do pozadí aplikace.
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (r) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.72, 1.0],
                    colors: [Colors.black, Colors.black, Colors.transparent],
                  ).createShader(r),
                  child: DayScene(time: time, dark: darkScene),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, insets.top + 12, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_weekdays[now.weekday - 1]} ${now.day}. ${_months[now.month - 1]}'
                                .toUpperCase(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: onScene.withValues(alpha: 0.8),
                              letterSpacing: 1.6,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            greeting,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: onScene,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: S.guide,
                      color: onScene,
                      onPressed: () => openGuide(context),
                      icon: const Icon(Icons.help_outline),
                    ),
                    IconButton(
                      tooltip: S.settings,
                      color: onScene,
                      style: IconButton.styleFrom(
                        backgroundColor: onScene.withValues(alpha: 0.14),
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.tune),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, heroHeight - 92, 20, 0),
                child: twoColumns
                    ? LayoutBuilder(
                        builder: (context, c) => Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: (c.maxWidth - gutter) / 2,
                            child: const _VerseOfDayCard(),
                          ),
                        ),
                      )
                    : const _VerseOfDayCard(),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: twoColumns
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: reading,
                      ),
                    ),
                    SizedBox(width: gutter),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: more,
                      ),
                    ),
                  ],
                )
              : const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [...reading, ...more],
                ),
        ),
      ],
    );
  }
}

class _VerseOfDayCard extends ConsumerWidget {
  const _VerseOfDayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verse = ref.watch(verseOfDayProvider).value;
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final target = verse?.ref ?? verseOfDay(DateTime.now());
    final book = ref.watch(bookByIdProvider(target.bookId));
    final abbr = ref.watch(primaryTranslationProvider).abbreviation;
    final citation = Citation.single(book.name, target);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.heroStart, palette.heroEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: palette.heroStart.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 6,
            top: -44,
            child: Text(
              '“',
              style: TextStyle(
                fontFamily: appFontFamily,
                fontSize: 150,
                color: palette.onHero.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: palette.gold),
                    const SizedBox(width: 6),
                    Text(
                      S.verseOfDay.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: palette.gold,
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    verse?.text.replaceAll('\n', ' ') ?? '…',
                    key: ValueKey(verse?.text),
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 20,
                      height: 1.5,
                      color: palette.onHero,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$citation · $abbr',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: palette.onHero.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: S.share,
                      color: palette.onHero,
                      icon: const Icon(Icons.ios_share),
                      onPressed: verse == null
                          ? null
                          : () => SharePlus.instance.share(
                              ShareParams(
                                text: '„${verse.text}“\n— $citation ($abbr)',
                              ),
                            ),
                    ),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        backgroundColor: palette.onHero.withValues(alpha: 0.16),
                        foregroundColor: palette.onHero,
                      ),
                      onPressed: () => openReaderAt(
                        context,
                        ref,
                        verseOfDay(DateTime.now()),
                      ),
                      child: const Text('Číst'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Odkaz do záložky Studium s ukázkou obsahu.
/// Rychlé zkratky do studijních materiálů (otevřou se rovnou).
class _SituationsStrip extends ConsumerWidget {
  const _SituationsStrip();

  static const _featured = [
    'fear',
    'anxiety',
    'sadness',
    'joy',
    'decision',
    'tired',
    'lonely',
    'gratitude',
    'guilt',
    'hope',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final all = ref.watch(situationsProvider).value?.$2 ?? const [];
    final featured = [
      for (final id in _featured) ...all.where((s) => s.id == id),
    ];
    void openAll() => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SituationsScreen()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(S.situationsToday, action: S.all, onAction: openAll),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: featured.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final s = featured[i];
              return ActionChip(
                avatar: Icon(
                  situationIcons[s.icon],
                  size: 18,
                  color: situationColor(s),
                ),
                label: Text(s.title),
                labelStyle: theme.textTheme.labelLarge,
                backgroundColor: palette.card,
                side: BorderSide(color: palette.cardBorder),
                onPressed: () => openSituation(context, s),
              );
            },
          ),
        ),
      ],
    );
  }
}
