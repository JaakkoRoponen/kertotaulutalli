import 'package:flutter/material.dart';

import 'screens/table_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kertotaulutalli',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primary: Colors.brown,
          secondary: Colors.amber,
        ),
        useMaterial3: true,
      ),
      home: const TableSelectionScreen(),
    );
  }
}
