import 'dart:async';
import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../data/passages.dart';
import '../models/test_config.dart';
import '../services/best_scores.dart';
import '../services/typing_stats.dart';
import '../widgets/passage_view.dart';
import 'results_screen.dart';

/// The typing test itself: passage on top, text field below, live stats.
/// The timer starts on the first keystroke. The test ends when time runs
/// out or the passage is finished.
class TestScreen extends StatefulWidget {
  const TestScreen({
    super.key,
    required this.settings,
    required this.bestScores,
  });

  final TestSettings settings;
  final BestScores bestScores;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late final Passage _passage;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _started = false;
  bool _finished = false;

  String _typed = '';
  int _totalKeystrokes = 0;
  int _correctKeystrokes = 0;
  bool _suppressChange = false;

  @override
  void initState() {
    super.initState();
    final pool = passagesFor(widget.settings.category)..shuffle(Random());
    _passage = pool.first;
    _remainingSeconds = widget.settings.length.seconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  int get _totalSeconds => widget.settings.length.seconds;

  Duration get _elapsed =>
      Duration(seconds: _totalSeconds - _remainingSeconds);

  double get _liveWpm => calculateWpm(
        correctChars: countCorrectChars(_passage.text, _typed),
        elapsed: _elapsed,
      );

  double get _liveAccuracy => calculateAccuracy(
        correctKeystrokes: _correctKeystrokes,
        totalKeystrokes: _totalKeystrokes,
      );

  void _startTimer() {
    _started = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 1) {
        _finish();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _onChanged(String value) {
    if (_suppressChange) {
      return;
    }
    // Cap input at the passage length.
    if (value.length > _passage.text.length) {
      _suppressChange = true;
      final capped = value.substring(0, _passage.text.length);
      _controller.value = TextEditingValue(
        text: capped,
        selection: TextSelection.collapsed(offset: capped.length),
      );
      _suppressChange = false;
      value = capped;
    }

    // Count keystrokes: only characters added since the last change.
    final old = _typed;
    if (value.length > old.length) {
      for (var i = old.length; i < value.length; i++) {
        _totalKeystrokes++;
        if (isCorrectKeystroke(
          target: _passage.text,
          index: i,
          typedChar: value[i],
        )) {
          _correctKeystrokes++;
        }
      }
    }

    setState(() => _typed = value);

    if (!_started && value.isNotEmpty) {
      _startTimer();
    }
    if (value.length >= _passage.text.length) {
      _finish();
    }
  }

  Future<void> _finish() async {
    if (_finished) {
      return;
    }
    _finished = true;
    _timer?.cancel();
    final correctChars = countCorrectChars(_passage.text, _typed);
    // A whole passage typed in under a second still counts as one second
    // of typing, so the WPM math never divides by zero.
    final timedElapsed =
        _elapsed.inSeconds == 0 ? const Duration(seconds: 1) : _elapsed;
    final wpm =
        calculateWpm(correctChars: correctChars, elapsed: timedElapsed);
    final accuracy = calculateAccuracy(
      correctKeystrokes: _correctKeystrokes,
      totalKeystrokes: _totalKeystrokes,
    );
    final isNewBest = await widget.bestScores.record(
      category: widget.settings.category,
      wpm: wpm,
      accuracy: accuracy,
    );
    if (!mounted) {
      return;
    }
    await Navigator.of(context).pushReplacement<bool, bool>(
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          result: TestResult(
            settings: widget.settings,
            passage: _passage,
            wpm: wpm,
            accuracy: accuracy,
            correctChars: correctChars,
            errors: countErrors(
              totalKeystrokes: _totalKeystrokes,
              correctKeystrokes: _correctKeystrokes,
            ),
            totalChars: _passage.text.length,
            elapsed: _elapsed,
            isNewBest: isNewBest,
          ),
          bestScores: widget.bestScores,
        ),
      ),
    );
  }

  String get _timeLabel {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const lime = Color(0xFFC8FF00);
    final progress = _totalSeconds == 0
        ? 0.0
        : (_totalSeconds - _remainingSeconds) / _totalSeconds;

    return Scaffold(
      appBar: AppBar(
        title: Text(_passage.title),
        backgroundColor: const Color(0xFF121212),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statChip('Time', _timeLabel, lime),
                  _statChip('WPM', _liveWpm.toStringAsFixed(0), lime),
                  _statChip(
                    'Accuracy',
                    '${_liveAccuracy.toStringAsFixed(0)}%',
                    lime,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFF333333),
                color: lime,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.settings.category.label} · ${widget.settings.length.label} test',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF757575),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PassageView(passage: _passage, typed: _typed),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: 4,
                minLines: 2,
                onChanged: _onChanged,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 17,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  hintText: _started
                      ? 'Keep typing…'
                      : 'Tap here and start typing — the timer starts on your first keystroke',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: lime, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${_typed.length} / ${_passage.text.length} characters',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF757575),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(String label, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFFBDBDBD)),
          ),
        ],
      ),
    );
  }
}
