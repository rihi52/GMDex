import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'theme/apptheme.dart';
import 'pages/home_page.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  await windowManager.setMinimumSize(
    const Size(1360, 800),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.dark(),
      home: const MyHomePage(),
    );
  }
}
