import 'package:flutter_test/flutter_test.dart';
import 'package:typeready/services/typing_stats.dart';

void main() {
  group('countCorrectChars', () {
    test('exact match counts every character', () {
      expect(countCorrectChars('hello world', 'hello world'), 11);
    });

    test('counts only matching positions', () {
      // 'hallo' vs 'hello': h matches, a != e, rest match.
      expect(countCorrectChars('hello', 'hallo'), 4);
    });

    test('extra characters past the target never count', () {
      expect(countCorrectChars('hi', 'hixyz'), 2);
    });

    test('empty typed text counts zero', () {
      expect(countCorrectChars('hello', ''), 0);
    });

    test('spaces count as characters', () {
      expect(countCorrectChars('a b c', 'a b c'), 5);
      expect(countCorrectChars('a b c', 'a x c'), 4);
    });
  });

  group('calculateWpm', () {
    test('300 correct chars in 60 seconds is 60 WPM', () {
      expect(
        calculateWpm(correctChars: 300, elapsed: const Duration(seconds: 60)),
        60,
      );
    });

    test('150 correct chars in 30 seconds is 60 WPM', () {
      expect(
        calculateWpm(correctChars: 150, elapsed: const Duration(seconds: 30)),
        60,
      );
    });

    test('scales with time: 100 chars in 2 minutes is 10 WPM', () {
      expect(
        calculateWpm(
          correctChars: 100,
          elapsed: const Duration(minutes: 2),
        ),
        10,
      );
    });

    test('zero elapsed time is 0 WPM, not infinity', () {
      expect(
        calculateWpm(correctChars: 100, elapsed: Duration.zero),
        0,
      );
    });

    test('zero correct chars is 0 WPM', () {
      expect(
        calculateWpm(correctChars: 0, elapsed: const Duration(seconds: 60)),
        0,
      );
    });
  });

  group('calculateAccuracy', () {
    test('90 of 100 keystrokes correct is 90%', () {
      expect(
        calculateAccuracy(correctKeystrokes: 90, totalKeystrokes: 100),
        90,
      );
    });

    test('all correct is 100%', () {
      expect(
        calculateAccuracy(correctKeystrokes: 50, totalKeystrokes: 50),
        100,
      );
    });

    test('nothing typed yet is 100%, not 0%', () {
      expect(
        calculateAccuracy(correctKeystrokes: 0, totalKeystrokes: 0),
        100,
      );
    });
  });

  group('countErrors', () {
    test('total minus correct', () {
      expect(
        countErrors(totalKeystrokes: 100, correctKeystrokes: 90),
        10,
      );
    });

    test('never goes negative', () {
      expect(
        countErrors(totalKeystrokes: 5, correctKeystrokes: 10),
        0,
      );
    });
  });

  group('isCorrectKeystroke', () {
    test('matching character is correct', () {
      expect(
        isCorrectKeystroke(target: 'hello', index: 1, typedChar: 'e'),
        isTrue,
      );
    });

    test('wrong character is incorrect', () {
      expect(
        isCorrectKeystroke(target: 'hello', index: 1, typedChar: 'a'),
        isFalse,
      );
    });

    test('index past the end is incorrect', () {
      expect(
        isCorrectKeystroke(target: 'hi', index: 5, typedChar: 'x'),
        isFalse,
      );
    });

    test('more than one character is incorrect', () {
      expect(
        isCorrectKeystroke(target: 'hello', index: 0, typedChar: 'he'),
        isFalse,
      );
    });
  });
}
