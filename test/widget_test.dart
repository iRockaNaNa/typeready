import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typeready/main.dart';
import 'package:typeready/services/best_scores.dart';
import 'package:typeready/widgets/passage_view.dart';

Future<void> pumpApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final scores = await BestScores.load();
  await tester.pumpWidget(TypeReadyApp(bestScores: scores));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('home screen shows the mode picker', (tester) async {
    await pumpApp(tester);

    expect(find.text('TypeReady'), findsWidgets);
    expect(find.text('Job Typing Test'), findsOneWidget);
    expect(find.text('1 min'), findsOneWidget);
    expect(find.text('3 min'), findsOneWidget);
    expect(find.text('5 min'), findsOneWidget);
    expect(find.text('General'), findsOneWidget);
    expect(find.text('Data Entry'), findsOneWidget);
    expect(find.text('Customer Support'), findsOneWidget);
    expect(find.text('Start test'), findsOneWidget);
  });

  testWidgets('tapping Start test opens the test screen', (tester) async {
    await pumpApp(tester);

    await tester.ensureVisible(find.text('Start test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start test'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(PassageView), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('WPM'), findsOneWidget);
    expect(find.text('Accuracy'), findsOneWidget);
  });

  testWidgets('typing the full passage shows the results screen',
      (tester) async {
    await pumpApp(tester);

    await tester.ensureVisible(find.text('Start test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start test'));
    await tester.pumpAndSettle();

    final passageView =
        tester.widget<PassageView>(find.byType(PassageView));
    final fullText = passageView.passage.text;

    await tester.enterText(find.byType(TextField), fullText);
    await tester.pumpAndSettle();

    expect(find.text('Results'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Change mode'), findsOneWidget);
    expect(find.textContaining('New best!'), findsOneWidget);
  });

  testWidgets('switching category updates the home screen', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Data Entry'));
    await tester.pump();
    await tester.ensureVisible(find.text('Start test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start test'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Data Entry'), findsWidgets);
  });
}
