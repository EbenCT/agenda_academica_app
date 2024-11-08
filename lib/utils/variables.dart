// ignore_for_file: file_names
//'10.0.2.2:8069/jsonrpc/' 

import '../datos/datos_user.dart';

//para las consultas por http
const ipOdoo = 'http://192.168.0.5:8069/jsonrpc/'; 
const dbName = 'prueba';
const int superid = 2;      
const superPassword = '1234';  

//Roles
const int estudiante = 65;    
const int representante = 66;
const int profesor = 67;

//Data User
final userId = DataUser().userId;
final userRole = DataUser().userRole;
final userPassword = DataUser().userPassword;