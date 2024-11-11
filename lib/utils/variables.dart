// ignore_for_file: file_names
//'10.0.2.2:8069/jsonrpc/' 

import 'package:agenda_academica/datos/datos_estudiante.dart';
import 'package:agenda_academica/datos/datos_padre.dart';
import 'package:agenda_academica/datos/datos_profesor.dart';

import '../datos/datos_user.dart';

//para las consultas por http
const ipOdoo = 'http://192.168.0.3:8069/jsonrpc'; 
const dbName = 'prueba';
const int superid = 2;      
const superPassword = '1234';  

//Para la conexion con ChatGPT
const apiKeyGPT = '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';
const apiKeyGemini = 'AIzaSyDHoVrUXtuWLLVFHDlS8xumQFjL-_TS_Dg';

//para visualizar elementos en los comunicados:
const rutaOdoo = 'http://192.168.0.3:8069/';

//Roles
const int estudiante = 65;    
const int representante = 66;
const int profesor = 67;

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