// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:agenda_academica/utils/variables.dart';
import 'package:http/http.dart' as http;

class AuthService {

  Future<int?> login(String email, String password) async {
    // Definir la URL de autenticación
    final url = Uri.parse(ipOdoo);

    // Construir el cuerpo de la solicitud JSON
    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "common",
        "method": "authenticate",
        "args": [dbName, email, password, {}]
      },
      "id": 1
    };

    try {
      // Realizar la solicitud POST
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(response.body);
        // Comprobar si se obtuvo un resultado válido
        if (jsonResponse["result"] != null) {
          return jsonResponse["result"]; // Devuelve el ID de usuario si el login es exitoso
        } else {
          print("Error en autenticación: ${jsonResponse['error']}");
          return null;
        }
      } else {
        print("Error HTTP: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return null;
    }
  }

  Future<int> checkRolUser(int userId, String password) async {
    final url = Uri.parse(ipOdoo);

    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName,
          superid,                       // ID del usuario autenticado
          password,                     // Contraseña del usuario
          "res.users",                  // Modelo en Odoo para los usuarios
          "read",                       // Método para leer detalles
          [[userId]],                   // ID del usuario cuyo rol se desea verificar
          {
            "fields": ["id", "name", "email", "groups_id"]  // Campos a leer
          }
        ]
      },
      "id": 3
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse["result"] != null) {
          // Obtén el groups_id del usuario
          List<dynamic> groups = jsonResponse["result"][0]["groups_id"];

          // Verifica el tipo de usuario con base en el contenido de groups_id
          if (groups.contains(estudiante)) {
            return estudiante;  //estudiante
          } else if (groups.contains(representante)) {
            return representante;  //padre/representante
          } else if (groups.contains(profesor)) {
            return profesor;  //profesor
          } else {
            return 1;   //admin
          }
        } else {
          print("Error en la obtención de roles: ${jsonResponse['error']}");
          return 0;
        }
      } else {
        print("Error HTTP: ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return 0;
    }
  }
}
