import 'package:shared_preferences/shared_preferences.dart';

import '../models/test_config.dart';

/// Best WPM and best accuracy, saved locally per passage category.
/// No account, no network — just shared_preferences.
class BestScores {
  BestScores(this._prefs);

  final SharedPreferences _prefs;

  static Future<BestScores> load() async {
    return BestScores(await SharedPreferences.getInstance());
  }

  static String _wpmKey(PassageCategory category) =>
      'best_wpm_${category.storageKey}';

  static String _accuracyKey(PassageCategory category) =>
      'best_accuracy_${category.storageKey}';

  double bestWpm(PassageCategory category) =>
      _prefs.getDouble(_wpmKey(category)) ?? 0;

  double bestAccuracy(PassageCategory category) =>
      _prefs.getDouble(_accuracyKey(category)) ?? 0;

  bool get hasAnyScore => PassageCategory.values.any(
        (c) => bestWpm(c) > 0 || bestAccuracy(c) > 0,
      );

  /// Records a finished test. Returns true when the run set a new best
  /// WPM or a new best accuracy for its category.
  Future<bool> record({
    required PassageCategory category,
    required double wpm,
    required double accuracy,
  }) async {
    var isNewBest = false;
    if (wpm > bestWpm(category)) {
      await _prefs.setDouble(_wpmKey(category), wpm);
      isNewBest = true;
    }
    if (accuracy > bestAccuracy(category)) {
      await _prefs.setDouble(_accuracyKey(category), accuracy);
      isNewBest = true;
    }
    return isNewBest;
  }
}
