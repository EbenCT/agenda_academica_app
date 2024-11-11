import 'dart:convert';
import 'package:agenda_academica/utils/variables.dart';
import 'package:http/http.dart' as http;

Future<void> getEventDetailsFromAI(String inputText) async {
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKeyGemini',
  );

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": "Por favor, analiza el siguiente texto para identificar los datos de un evento y responde en formato JSON. Extrae los datos del nombre del evento, la fecha de inicio (las fechas deben tener este formato: 2024-11-01 10:00:00) y la fecha de fin (si no se proporciona fecha de inicio le colocas la fecha actual, y si no proporciona fecha de fin le colocas la misma que fecha que la de inicio). Solo proporciona la respuesta en JSON. Ejemplo del formato de respuesta esperado:\n\n{\n  \"name\": \"Nombre del evento\",\n  \"start_date\": \"YYYY-MM-DD HH:MM:SS\",\n  \"end_date\": \"YYYY-MM-DD HH:MM:SS\"\n}\n\nTexto a analizar: \"$inputText\""
            }
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
    // Extraer el contenido JSON de Gemini
    final candidates = data['candidates'];
    print(candidates);
    if (candidates != null && candidates.isNotEmpty) {
      var eventJsonText = candidates[0]['content']['parts'][0]['text'];
      // Limpiar el texto JSON eliminando ```json y ``` si están presentes
      eventJsonText = eventJsonText
          .replaceAll(RegExp(r'^```json|```$'), '')
          .trim();

      try {
        // Convertir el texto JSON en un Map de Dart
        final eventDetails = jsonDecode(eventJsonText);

        print('Detalles del evento extraídos: $eventDetails');

        // Llama a createEvent pasando el JSON ya extraído y convertido en un Map
        await createEvent(eventDetails);
      } catch (e) {
        print('Error al decodificar JSON: $e');
      }
    } else {
      print('No se encontraron datos en la respuesta de Gemini.');
    }
  } else {
    print('Error en la solicitud: ${response.statusCode}');
  }
}

Future<void> createEvent(Map<String, dynamic> geminiResponse) async {
  // Extrae los valores del JSON de respuesta de Gemini
  final name = geminiResponse['name'] ?? 'Evento sin título';
  final startDate = geminiResponse['start_date'] ?? '2024-11-01T10:00:00';
  final endDate = geminiResponse['end_date'] ?? '2024-11-01T12:00:00';

  // Construye el cuerpo de la solicitud JSON-RPC
  final requestBody = {
    "jsonrpc": "2.0",
    "method": "call",
    "params": {
      "service": "object",
      "method": "execute_kw",
      "args": [
        dbName,
        userId,
        userPassword,
        "academy.event",
        "create",
        [
          {
            "name": name,
            "start_date": startDate,
            "end_date": endDate,
            "event_type": "academic"  // Ajusta según tu modelo
          }
        ]
      ]
    },
    "id": 3
  };

  // Envía la solicitud JSON-RPC
  final url = Uri.parse(ipOdoo);
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    print('Evento creado exitosamente: ${response.body}');
  } else {
    print('Error al crear el evento: ${response.statusCode} ${response.body}');
  }
}
