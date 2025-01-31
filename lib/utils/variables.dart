// ignore_for_file: file_names
//'10.0.2.2:8069/jsonrpc/' 

import 'package:agenda_academica/datos/datos_estudiante.dart';
import 'package:agenda_academica/datos/datos_padre.dart';
import 'package:agenda_academica/datos/datos_profesor.dart';

import '../datos/datos_user.dart';

//para las consultas por http
const ipOdoo = 'http://165.227.176.190/jsonrpc'; // http://192.168.0.3:8069/jsonrpc  165.227.176.190
const dbName = 'partial';        // prueba
const int superid = 2;          //2
const superPassword = 'admin';   // 1234

//Para la conexion con ChatGPT
const apiKeyGPT = '';
const apiKeyGemini = '';
const apiKeyGoogle = '';

//para visualizar elementos en los comunicados:
const rutaOdoo = 'http://165.227.176.190/';  // http://192.168.0.3:8069/   165.227.176.190

//Roles
const int estudiante = 22;      //65
const int representante = 23;   //66
const int profesor = 24;        //67

//Data User
final userId = DataUser().userId;
final userRole = DataUser().userRole;
final userPassword = DataUser().userPassword;

//Data Student
final studentId = DataStudent().studentId;
final cursoId = DataStudent().currentCourse?['course_id'];

//Data Teacher
final profeId = DataTeacher().teacherId;
List<int>? courseIds = DataTeacher().courseIds;

//Data Padre
final padreId = DataParent().parentId;
Future<List<int>>? hijosIds;
//Para las notificaciones
String tokenDevice = '';