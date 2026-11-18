# TypeReady — Job Typing Test

A Nanatech Creative Studios app that practices the typing speed and
accuracy tests remote jobs run before interview. Pick a test length and
a passage type, type what you see, and get your WPM and accuracy with
every mistake highlighted so you know what to fix.

No account. No ads. Works offline.

## v1 features

- **Home screen** — pick a test length (1 / 3 / 5 minutes) and a passage
  category (General, Data Entry, Customer Support). Shows your best WPM
  and best accuracy for the selected category, saved on the device.
- **Test screen** — the passage with per-character coloring: correct
  characters in white, mistakes in red, the next character underlined in
  lime. Live timer, live WPM, live accuracy. The timer starts on your
  first keystroke. The test ends when time runs out or you finish the
  passage.
- **Results screen** — final WPM, accuracy %, correct characters, and
  errors, plus a "New best!" badge when you beat a saved best. Buttons
  for Try again (same settings) and Change mode.
- **Best scores** — best WPM and best accuracy are saved per category in
  shared preferences, on the device only.
- **12 passages** — 4 General, 4 Data Entry (names, numbers, dollar
  amounts, addresses, dates), 4 Customer Support (order status, refund,
  password reset, shipping delay). Written for this app, 60–90 words
  each. No lorem ipsum.
- **Scoring** — standard job-test math: WPM = (correct characters / 5) /
  minutes elapsed; accuracy = correct keystrokes / total keystrokes
  typed. The math lives in `lib/services/typing_stats.dart` and is unit
  tested.

## Build it

Toolchain: Flutter 3.50.0, Dart 3.14, AGP 9.3.1, Kotlin 2.4.20,
Gradle 9.5.0, compileSdk 36, minSdk 24, Java 17.

```sh
# From the project root. The user runs these — this repo is a local
# copy, not pushed anywhere yet.
flutter pub get
flutter analyze
flutter test

# Android (debug APK for sideloading / testing)
flutter build apk --debug

# Web (for the site below)
flutter build web
```

## Deploy

### Android

Install the debug APK from `build/app/outputs/flutter-apk/` on a phone,
or set up a Play Console listing later (needs the $25 account and a
closed test track — same as the weather app).

### Web — https://typingbananas.app

The web app lives at **https://typingbananas.app**, served free via
GitHub Pages. The domain is **bought** — Porkbun, Order 12609605,
$7.75 total, paid through 2027-11-18, renews ~$14.93/yr. DNS is at
Porkbun.

Setup (one time):

1. Create the GitHub repo for this project and push it (the user does
   this — repos are his to create).
2. In the repo, enable **GitHub Pages** (Settings → Pages), serving from
   the `main` branch.
3. In the Pages settings, set the **custom domain** to
   `typingbananas.app`. GitHub writes a `CNAME` file containing that
   hostname into the published site.
4. In Porkbun's DNS for the domain, point it at GitHub Pages: add the
   A records GitHub specifies for an apex custom domain
   (`185.199.108.153`, `185.199.109.153`, `185.199.110.153`,
   `185.199.111.153`), and optionally a `www` CNAME pointing at
   `irockanana.github.io`.
5. Build and publish the web output to the repo:
   `flutter build web` and put the contents of `build/web/` on the
   branch GitHub Pages serves.

Because the app is served from the root of its domain, the Flutter web
build uses the default base href `/` — no `--base-href` flag needed.

### iOS

iOS builds need a Mac with Xcode (or a cloud Mac runner on GitHub
Actions — see "Planned later"). There is no iOS build path from the
Windows/WSL machine alone. iPhone testing coming soon — (PRODUCT)RED
iPhone 11 (daily watch, under $150).

## Planned later

- Premium job-mode packs (more passage packs by job type).
- Custom text: paste your own practice text.
- History graph: WPM and accuracy over time.
- iOS: build via a cloud Mac runner (GitHub Actions macOS runner),
  since the team has no Mac; test on a (PRODUCT)RED iPhone 11
  (daily watch running, under $150).
- Streaks and daily practice reminders.
- A "job test" mode that mimics a real hiring test end to end.

## License

MIT — see [LICENSE](LICENSE). Copyright (c) 2026 Nanatech Creative Studios.
