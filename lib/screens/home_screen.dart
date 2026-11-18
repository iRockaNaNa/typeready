import 'package:material_ui/material_ui.dart';

import '../models/test_config.dart';
import '../services/best_scores.dart';
import 'test_screen.dart';

/// Home screen: pick a test length and a passage category, then start.
/// Shows the saved best WPM and best accuracy for the selected category.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.bestScores});

  final BestScores bestScores;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TestLength _length = TestLength.oneMinute;
  PassageCategory _category = PassageCategory.general;

  @override
  Widget build(BuildContext context) {
    const lime = Color(0xFFC8FF00);
    final bestWpm = widget.bestScores.bestWpm(_category);
    final bestAccuracy = widget.bestScores.bestAccuracy(_category);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TypeReady'),
        backgroundColor: const Color(0xFF121212),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Job Typing Test',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Practice the speed and accuracy tests remote jobs run before '
              'interview. Pick a length and a passage type, then type what '
              'you see.',
              style: TextStyle(fontSize: 15, color: Color(0xFFBDBDBD)),
            ),
            const SizedBox(height: 24),
            _sectionLabel('Test length'),
            const SizedBox(height: 8),
            Row(
              children: TestLength.values.map((length) {
                final selected = length == _length;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(length.label),
                      selected: selected,
                      selectedColor: lime,
                      labelStyle: TextStyle(
                        color: selected
                            ? const Color(0xFF121212)
                            : const Color(0xFFF5F5F5),
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) {
                        setState(() => _length = length);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _sectionLabel('Passage type'),
            const SizedBox(height: 8),
            ...PassageCategory.values.map((category) {
              final selected = category == _category;
              return Card(
                color: selected
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: selected ? lime : const Color(0xFF333333),
                    width: selected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    category.label,
                    style: TextStyle(
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(category.blurb),
                  trailing: selected
                      ? const Icon(Icons.check_circle, color: lime)
                      : null,
                  onTap: () {
                    setState(() => _category = category);
                  },
                ),
              );
            }),
            const SizedBox(height: 24),
            if (bestWpm > 0 || bestAccuracy > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _bestStat('Best WPM', bestWpm.toStringAsFixed(0)),
                    _bestStat(
                      'Best accuracy',
                      '${bestAccuracy.toStringAsFixed(0)}%',
                    ),
                  ],
                ),
              ),
            if (bestWpm > 0 || bestAccuracy > 0) const SizedBox(height: 24),
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
              onPressed: () async {
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => TestScreen(
                      settings: TestSettings(
                        length: _length,
                        category: _category,
                      ),
                      bestScores: widget.bestScores,
                    ),
                  ),
                );
                // A finished test may have set a new best — refresh.
                if (result == true && mounted) {
                  setState(() {});
                }
              },
              child: const Text('Start test'),
            ),
            const SizedBox(height: 16),
            const Text(
              'By Nanatech Creative Studios · No account, no ads, works offline',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFFC8FF00),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _bestStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC8FF00),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFFBDBDBD)),
        ),
      ],
    );
  }
}
