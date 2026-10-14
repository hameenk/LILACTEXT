import 'package:flutter/material.dart';
import 'package:textproject/screen/app_theme.dart';
import 'package:textproject/screen/splsh_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExpenziaApp());
}

class ExpenziaApp extends StatelessWidget {
  const ExpenziaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Expenzia',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const SplashScreen(),
  );
}
