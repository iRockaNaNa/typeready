// Pure typing-test math. No Flutter, no I/O — unit tested in
// test/typing_stats_test.dart.
//
// Definitions (the standard ones job typing tests use):
// * WPM = (correct characters / 5) / minutes elapsed. One "word" is 5
//   characters, spaces included.
// * Accuracy = correct keystrokes / total keystrokes typed, as a percent.
//   A keystroke counts when a character is typed; backspacing does not
//   count, but retyping a character counts again.

/// Counts the characters where [typed] matches [target] at the same index.
/// Extra characters past the end of [target] never count as correct.
int countCorrectChars(String target, String typed) {
  var correct = 0;
  final n = typed.length < target.length ? typed.length : target.length;
  for (var i = 0; i < n; i++) {
    if (typed.codeUnitAt(i) == target.codeUnitAt(i)) {
      correct++;
    }
  }
  return correct;
}

/// Words per minute from [correctChars] typed in [elapsed].
/// Returns 0 when nothing has been typed yet or no time has passed.
double calculateWpm({
  required int correctChars,
  required Duration elapsed,
}) {
  if (correctChars <= 0 || elapsed.inMilliseconds <= 0) {
    return 0;
  }
  final minutes = elapsed.inMilliseconds / 60000.0;
  return (correctChars / 5) / minutes;
}

/// Accuracy as a percent (0-100) from keystroke counts.
/// Returns 100 when nothing has been typed yet, so a fresh test
/// does not start at 0%.
double calculateAccuracy({
  required int correctKeystrokes,
  required int totalKeystrokes,
}) {
  if (totalKeystrokes <= 0) {
    return 100;
  }
  return correctKeystrokes / totalKeystrokes * 100;
}

/// How many keystrokes in [newTyped] were wrong, compared with [target].
/// (Total keystrokes minus correct keystrokes — the caller tracks totals.)
int countErrors({
  required int totalKeystrokes,
  required int correctKeystrokes,
}) {
  final errors = totalKeystrokes - correctKeystrokes;
  return errors < 0 ? 0 : errors;
}

/// Result of comparing a newly typed character against the passage.
/// Used by the test screen to count keystrokes as they happen.
bool isCorrectKeystroke({
  required String target,
  required int index,
  required String typedChar,
}) {
  if (index < 0 || index >= target.length || typedChar.length != 1) {
    return false;
  }
  return target[index] == typedChar;
}
