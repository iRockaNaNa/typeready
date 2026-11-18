import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typeready/models/test_config.dart';
import 'package:typeready/services/best_scores.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('fresh install has no bests', () async {
    final scores = await BestScores.load();
    expect(scores.bestWpm(PassageCategory.general), 0);
    expect(scores.bestAccuracy(PassageCategory.general), 0);
    expect(scores.hasAnyScore, isFalse);
  });

  test('recording a run saves both bests and reports a new best', () async {
    final scores = await BestScores.load();
    final isNewBest = await scores.record(
      category: PassageCategory.dataEntry,
      wpm: 42,
      accuracy: 91,
    );
    expect(isNewBest, isTrue);
    expect(scores.bestWpm(PassageCategory.dataEntry), 42);
    expect(scores.bestAccuracy(PassageCategory.dataEntry), 91);
    expect(scores.hasAnyScore, isTrue);
  });

  test('a worse run does not overwrite bests', () async {
    final scores = await BestScores.load();
    await scores.record(
      category: PassageCategory.general,
      wpm: 50,
      accuracy: 95,
    );
    final isNewBest = await scores.record(
      category: PassageCategory.general,
      wpm: 30,
      accuracy: 80,
    );
    expect(isNewBest, isFalse);
    expect(scores.bestWpm(PassageCategory.general), 50);
    expect(scores.bestAccuracy(PassageCategory.general), 95);
  });

  test('WPM and accuracy are tracked independently', () async {
    final scores = await BestScores.load();
    await scores.record(
      category: PassageCategory.customerSupport,
      wpm: 40,
      accuracy: 90,
    );
    // Faster but sloppier: new best WPM only.
    final isNewBest = await scores.record(
      category: PassageCategory.customerSupport,
      wpm: 55,
      accuracy: 85,
    );
    expect(isNewBest, isTrue);
    expect(scores.bestWpm(PassageCategory.customerSupport), 55);
    expect(scores.bestAccuracy(PassageCategory.customerSupport), 90);
  });

  test('bests are per category', () async {
    final scores = await BestScores.load();
    await scores.record(
      category: PassageCategory.general,
      wpm: 60,
      accuracy: 99,
    );
    expect(scores.bestWpm(PassageCategory.dataEntry), 0);
    expect(scores.bestWpm(PassageCategory.customerSupport), 0);
  });
}
