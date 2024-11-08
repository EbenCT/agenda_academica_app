import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/variables.dart';
import '../models/events.dart';

class EventService {

  // Obtiene los eventos de la API de Odoo
  Future<List<Event>> fetchEvents() async {
    final url = Uri.parse(ipOdoo);

    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName,         // Nombre de la base de datos
          superid,              // ID del usuario autenticado
          userPassword,         // Contraseña del usuario
          "academy.event",  // Modelo en Odoo
          "search_read",    // Método para leer datos
          [],
          {
            "fields": [
              "name",
              "start_date",
              "end_date",
              "event_type",
              "priority",
              "state",
              "description"
            ]
          }
        ]
      },
      "id": 2
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> result = data["result"];

      return result.map((eventData) {
        final name = eventData['name'] ?? 'Sin título';
        final start = DateTime.parse(eventData['start_date']);
        final end = DateTime.parse(eventData['end_date']);
        final eventType = eventData['event_type'];
        final priority = eventData['priority'];
        final state = eventData['state'];
        final description = eventData['description'].toString();

        return Event(
          title: name,
          start: start,
          end: end,
          eventType: eventType,
          priority: priority,
          state: state,
          description: description,
        );
      }).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
