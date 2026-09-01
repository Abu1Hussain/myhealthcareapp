# MyHealth AI — Broadsheet redesign, part 1 of 2

Drop-in replacements for the theme layer and the shared widgets. **No public API
changed** — every class name, constructor, named parameter, factory and constant
that existed before still exists, so the 24 screens keep compiling untouched and
pick up the new look immediately.

## Files in this patch

    lib/app/theme/app_colors.dart
    lib/app/theme/app_typography.dart
    lib/app/theme/app_spacing.dart
    lib/app/theme/app_theme.dart
    lib/features/shared/clinical_badge.dart
    lib/features/shared/double_bezel_card.dart
    lib/features/shared/skeletal_shimmer.dart
    lib/features/shared/staggered_fade_slide.dart
    lib/features/shared/safety_banner.dart
    lib/features/shared/empty_state_widget.dart
    lib/services/clinical/appointment_triage_service.dart

Copy them over the same paths in the repo, run `flutter pub get`, then
`flutter analyze`. Nothing new is needed in `pubspec.yaml` — `google_fonts`
is already a dependency.

## What changed

**Colour.** Six competing accents reduced to two inks. `AppColors.primaryTeal`
and friends still exist but now hold Broadsheet's cyan (#0088b0) — the single
interactive ink. `critical` holds the magenta spot (#d6006c), reserved for real
clinical alarm. `success`, `warning` and `info` now resolve to steps on the
neutral ramp: status stops shouting in colour and reads as printer's grey.
`aiAccent` is no longer violet — AI surfaces use the same cyan as everything
else, because "this came from a model" is stated in words, not hue.

**Risk bands.** `riskLow / riskMedium / riskHigh` are three steps of one grey
wedge instead of green/amber/red. `ClinicalBadge.riskBand()` renders them as a
tonal scale, so a high band reads as *heavier*, not *differently coloured*.
This also retires the whole "badge text-on-tint" contrast workaround: every
tint/text pair here is a 100-step ground against an 800-step ink, which clears
AA by a wide margin in both themes.

**Type.** `GoogleFonts.outfit` → `GoogleFonts.sourceSerif4` throughout. The
`mono()` and `monoSmall()` helpers survive by name but now return the same
serif with tabular figures — Broadsheet forbids introducing a second UI face,
and tabular serif numerals line up in columns just as well.

> If your `google_fonts` version predates Source Serif 4, bump it or swap
> `sourceSerif4` for `sourceSerifPro` in `app_typography.dart` and
> `app_theme.dart`.

**Shape and elevation.** Card radius 20 → 2. `AppElevation.cardShadow` drops
from a 40px diffused shadow to Broadsheet's `--shadow-sm`; the page is paper,
so almost nothing floats. `AppSpacing` moves onto the system's 1.25× scale
(5 / 10 / 15 / 20 / 30 / 40).

**`DoubleBezelCard`.** Same name, same parameters, no more double bezel. It is
now a flat block that separates by a hairline rule and whitespace rather than
by a bordered, shadowed box — Broadsheet structures pages with space, not
boxes. Pass `filled: true` (new, optional) where you genuinely want the
surface tint back, e.g. a discrete listing.

**Motion.** `StaggeredFadeSlide` default stagger 25ms → 70ms with a
spring-weighted curve, so a list arrives as a cascade you can see rather than a
uniform blink. `SkeletalShimmer` keeps its API and moves onto the neutral
ramp. The only perpetual loop left in the app is the pulsing dot on a critical
badge.

**Dark mode.** Broadsheet ships no dark ground, so this is a documented
extension: the ink and paper roles invert onto the neutral ramp
(#1b1a19 canvas, #262322 surface) and the accent steps up to `accent-400` to
hold contrast on a dark field. Values live in one place if you want to retune.

## Still to come (part 2)

The eight screen rewrites — patient shell + Today, Chart, AI reading, Vitals,
booking wizard, clinician day, admin console, login — including the 6→4 bottom
nav consolidation. Those touch layout and copy, not just tokens, so they ship
separately.
