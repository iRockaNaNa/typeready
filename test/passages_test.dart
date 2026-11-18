import 'package:flutter_test/flutter_test.dart';
import 'package:typeready/data/passages.dart';
import 'package:typeready/models/test_config.dart';

void main() {
  test('there are 12 passages, 4 per category', () {
    expect(passages.length, 12);
    for (final category in PassageCategory.values) {
      expect(passagesFor(category).length, 4);
    }
  });

  test('every passage has a unique id and a title', () {
    final ids = passages.map((p) => p.id).toSet();
    expect(ids.length, passages.length);
    for (final passage in passages) {
      expect(passage.title, isNotEmpty);
      expect(passage.text, isNotEmpty);
    }
  });

  test('every passage is 60-90 words (a fair test length)', () {
    for (final passage in passages) {
      expect(
        passage.wordCount,
        inInclusiveRange(60, 90),
        reason: '${passage.id} has ${passage.wordCount} words',
      );
    }
  });

  test('data entry passages contain numbers', () {
    for (final passage in passagesFor(PassageCategory.dataEntry)) {
      expect(
        RegExp(r'\d').hasMatch(passage.text),
        isTrue,
        reason: '${passage.id} has no digits',
      );
    }
  });

  test('no passage is lorem ipsum', () {
    for (final passage in passages) {
      expect(passage.text.toLowerCase(), isNot(contains('lorem')));
    }
  });
}
