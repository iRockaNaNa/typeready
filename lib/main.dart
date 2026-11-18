import 'package:material_ui/material_ui.dart';

import 'screens/home_screen.dart';
import 'services/best_scores.dart';

/// TypeReady — Job Typing Test by Nanatech Creative Studios.
/// Practice typing speed and accuracy for the tests remote jobs run
/// before interview. No account, no ads, works offline.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bestScores = await BestScores.load();
  runApp(TypeReadyApp(bestScores: bestScores));
}

class TypeReadyApp extends StatelessWidget {
  const TypeReadyApp({super.key, required this.bestScores});

  final BestScores bestScores;

  @override
  Widget build(BuildContext context) {
    const lime = Color(0xFFC8FF00);
    return MaterialApp(
      title: 'TypeReady — Job Typing Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: lime,
          secondary: lime,
          surface: Color(0xFF1E1E1E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Color(0xFFF5F5F5),
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(bestScores: bestScores),
    );
  }
}
