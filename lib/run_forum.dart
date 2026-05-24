import 'package:flutter/material.dart';
import 'pages/forum_page.dart';

void main() {
  runApp(const RunForumApp());
}

class RunForumApp extends StatelessWidget {
  const RunForumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForumPage(),
    );
  }
}