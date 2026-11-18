import 'package:material_ui/material_ui.dart';

import '../data/passages.dart';

/// Shows a passage with per-character coloring:
/// * typed correctly — normal text (white)
/// * typed incorrectly — red
/// * next character to type — lime underline
/// * not yet typed — dim grey
class PassageView extends StatelessWidget {
  const PassageView({
    super.key,
    required this.passage,
    required this.typed,
  });

  final Passage passage;
  final String typed;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 19,
      height: 1.7,
      color: Color(0xFFBDBDBD),
    );
    const correctStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 19,
      height: 1.7,
      color: Color(0xFFF5F5F5),
    );
    const wrongStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 19,
      height: 1.7,
      color: Color(0xFFFF5252),
      backgroundColor: Color(0x33FF5252),
    );
    const currentStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 19,
      height: 1.7,
      color: Color(0xFFC8FF00),
      decoration: TextDecoration.underline,
      decorationColor: Color(0xFFC8FF00),
      decorationThickness: 2,
    );

    final target = passage.text;
    final spans = <TextSpan>[];
    for (var i = 0; i < target.length; i++) {
      final ch = target[i];
      TextStyle style;
      if (i < typed.length) {
        style = typed[i] == ch ? correctStyle : wrongStyle;
      } else if (i == typed.length) {
        style = currentStyle;
      } else {
        style = textStyle;
      }
      spans.add(TextSpan(text: ch, style: style));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
