import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note/modules/noteScreen/NoteScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Ubuntu',
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: HexColor('161717'),
        ),
        scaffoldBackgroundColor: Colors.grey.shade800.withOpacity(.5),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: HexColor('29b1b1'),
          iconSize: 24.0,
        ),
      ),
      home: const Note(),
    );
  }
}
