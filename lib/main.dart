import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dupe/screens/home_page.dart';
import 'package:dupe/screens/kanban_page.dart';
import 'package:dupe/screens/task_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Kanban desks';
  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomePage(),
    );
}
