import 'package:agenda_academica/pages/comunicados/comunicados.dart';
import 'package:agenda_academica/pages/cursos.dart';
import 'package:agenda_academica/pages/materias/materias.dart';
import 'package:agenda_academica/pages/perfil.dart';
import 'package:flutter/material.dart';

import 'config/app_theme.dart';
import 'pages/calendario/calendario.dart';
import 'pages/login.dart';
import 'pages/hijos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme(selectedColor: 1).getTheme(),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/calendario': (context) => const CalendarioPage(),
        '/hijos':(context) => const ChildPage(),
        '/perfil':(context) => ProfilePage(),
        '/materias':(context) => const MateriasPage(),
        '/cursos':(context) => const CursosPage(),
        '/comunicados':(context) => const ComunicadosPage()
      }
    );
  }
}