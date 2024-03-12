import 'package:flutter/material.dart';
import 'package:crystal_tarea_seis/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: const Text(
              'Crystal Tarea 6',
          style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.pink,
        ),
        body: Center(
          child: Image.asset(
            'assets/images/AHB-533K01.png',
            width: 350.0,
            height: 350.0,
          ),
        ),
      )
    );
  }
}




