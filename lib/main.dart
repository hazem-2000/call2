import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/bloc_obServer.dart';
import 'package:todo/firstPage.dart';
import 'package:todo/home%20layout.dart';
import 'package:todo/pdf.dart';

void main() {
  BlocOverrides.runZoned(
        () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: FirstPage(),
    );
  }
}


