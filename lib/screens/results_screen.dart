import 'package:material_ui/material_ui.dart';

import '../data/passages.dart';
import '../models/test_config.dart';
import '../services/best_scores.dart';
import 'test_screen.dart';

/// The outcome of one finished test run.
class TestResult {
  const TestResult({
    required this.settings,
    required this.passage,
    required this.wpm,
    required this.accuracy,
    required this.correctChars,
    required this.errors,
    required this.totalChars,
    required this.elapsed,
    required this.isNewBest,
  });

  final TestSettings settings;
  final Passage passage;
  final double wpm;
  final double accuracy;
  final int correctChars;
  final int errors;
  final int totalChars;
  final Duration elapsed;
  final bool isNewBest;
}

/// Results screen: final WPM, accuracy, correct chars and errors,
/// a "New best!" badge when the run beat a saved best, and buttons
/// to try again or change mode.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.result,
    required this.bestScores,
  });

  final TestResult result;
  final BestScores bestScores;

  String get _elapsedLabel {
    final minutes = result.elapsed.inMinutes;
    final seconds = result.elapsed.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const lime = Color(0xFFC8FF00);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: const Color(0xFF121212),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (result.isNewBest)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: lime,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '🎉 New best!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF121212),
                  ),
                ),
              ),
            if (result.isNewBest) const SizedBox(height: 20),
            Text(
              result.passage.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Color(0xFFBDBDBD)),
            ),
            Text(
              '${result.settings.category.label} · ${result.settings.length.label} test · $_elapsedLabel',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bigStat('WPM', result.wpm.toStringAsFixed(0), lime),
                _bigStat(
                  'Accuracy',
                  '${result.accuracy.toStringAsFixed(0)}%',
                  lime,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _detailRow(
                    'Correct characters',
                    '${result.correctChars} / ${result.totalChars}',
                  ),
                  const Divider(color: Color(0xFF333333)),
                  _detailRow('Errors', '${result.errors}'),
                  const Divider(color: Color(0xFF333333)),
                  _detailRow(
                    'Best WPM (${result.settings.category.label})',
                    bestScores.bestWpm(result.settings.category).toStringAsFixed(0),
                  ),
                  const Divider(color: Color(0xFF333333)),
                  _detailRow(
                    'Best accuracy (${result.settings.category.label})',
                    '${bestScores.bestAccuracy(result.settings.category).toStringAsFixed(0)}%',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: lime,
                foregroundColor: const Color(0xFF121212),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => TestScreen(
                      settings: result.settings,
                      bestScores: bestScores,
                    ),
                  ),
                );
              },
              child: const Text('Try again'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFF5F5F5),
                side: const BorderSide(color: Color(0xFF757575)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Change mode'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bigStat(String label, String value, Color accent) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: accent,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
