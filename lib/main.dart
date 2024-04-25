// ignore: unused_import
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_7_pay/src/page/consulta_endere%C3%A7os_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViaCEP API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConsultarEnderecosPage(),
    );
  }
}
