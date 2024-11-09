import 'dart:convert';

import 'package:agenda_academica/service/eventService.dart';
import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/events.dart';

class ComunicadosPage extends StatefulWidget {
  const ComunicadosPage({super.key});

  @override
  _ComunicadosPageState createState() => _ComunicadosPageState();
}

class _ComunicadosPageState extends State<ComunicadosPage> {
  final EventService _comunicadosService = EventService();
  List<Event> comunicados = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComunicados();
  }

  Future<void> _fetchComunicados() async {
    try {
      final fetchedComunicados = await _comunicadosService.fetchFilteredEvents();
      setState(() {
        comunicados = fetchedComunicados;
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar comunicados: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunicados'),
        backgroundColor: theme.colorScheme.primary,
      ),
      drawer: CustomDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: comunicados.length,
              itemBuilder: (context, index) {
                final comunicado = comunicados[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: theme.colorScheme.background,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comunicado.title,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Tipo: ${comunicado.eventType}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Fecha: ${comunicado.start} - ${comunicado.end}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Responsable: ${comunicado.responsibleId[1]}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        Html(
                          data: comunicado.description,
                          onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, _) {
                            if (url != null) {
                              _launchURL(url);
                            }
                          },
                          onImageTap: (String? src, RenderContext context, Map<String, String> attributes, _) {
                            // Aquí puedes hacer algo al tocar una imagen (si lo necesitas)
                          },
                          style: {
                            "p": Style(
                              color: theme.colorScheme.onBackground,
                            ),
                          },
                          customRender: {
                            "video": (RenderContext context, Widget child) {
                              final videoUrl = context.tree.element?.attributes['src'];
                              return GestureDetector(
                                onTap: () {
                                  if (videoUrl != null) _launchURL(videoUrl);
                                },
                                child: Text(
                                  'Ver video',
                                  style: TextStyle(color: theme.colorScheme.secondary),
                                ),
                              );
                            },
                            "file": (RenderContext context, Widget child) {
                              final fileData = context.tree.element?.attributes['data-embedded-props'];
                              if (fileData != null) {
                                final decodedData = jsonDecode(fileData);
                                final fileUrl = decodedData['fileData']['url'];
                                return ElevatedButton(
                                  onPressed: () {
                                    if (fileUrl != null) _launchURL(fileUrl);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                  child: Text('Descargar archivo'),
                                );
                              }
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Método para abrir URLs (enlaces, videos y archivos)
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("No se pudo abrir el enlace: $url");
    }
  }
}
