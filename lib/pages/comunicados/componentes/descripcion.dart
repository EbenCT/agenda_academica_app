import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContentViewer extends StatelessWidget {
  final String htmlContent;
  final String baseUrl;

  const ContentViewer({
    Key? key,
    required this.htmlContent,
    required this.baseUrl,
  }) : super(key: key);

  Future<void> _launchURL(String urlString) async {
    try {
      // Asegurarse de que la URL del archivo tenga el formato correcto
      if (urlString.contains('/jsonrpc/')) {
        urlString = urlString.replaceAll('/jsonrpc/', '/web/content/');
      }
      
      await launchUrlString(
        urlString,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
    } catch (e) {
      debugPrint("Error al abrir URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Html(
      data: htmlContent,
      style: {
        "p": Style(
          color: theme.colorScheme.onSurface,
        ),
        "img": Style(
          width: Width(300),
        ),
      },
      onAnchorTap: (url, _, __) {
        if (url != null) {
          _launchURL(url);
        }
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"img"},
          builder: (extensionContext) {
            final imageUrl = extensionContext.element?.attributes['src'];
            if (imageUrl != null) {
              final fullUrl = imageUrl.startsWith('http') 
                  ? imageUrl 
                  : baseUrl + (imageUrl.startsWith('/') ? imageUrl.substring(1) : imageUrl);
              
              return Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) => Dialog(
                        child: Image.network(
                          fullUrl,
                          headers: const {
                            'Accept': 'image/*',
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / 
                                      loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('Error loading image: $error');
                            return const Center(
                              child: Icon(Icons.error_outline, color: Colors.red, size: 50)
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    fullUrl,
                    headers: const {
                      'Accept': 'image/*',
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Error loading image: $error');
                      return const Center(
                        child: Icon(Icons.error_outline, color: Colors.red, size: 50)
                      );
                    },
                  ),
                ),
              );
            }
            return Container();
          },
        ),
        TagExtension(
          tagsToExtend: {"div"},
          builder: (extensionContext) {
            final element = extensionContext.element;
            
            return Builder(
              builder: (context) {
                // Manejo de videos
                if (element?.attributes['data-embedded'] == 'video') {
                  try {
                    final embedProps = element?.attributes['data-embedded-props'] ?? '';
                    final videoData = jsonDecode(embedProps);
                    final videoId = videoData['videoId'] as String;
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('Ver video de YouTube'),
                        onPressed: () {
                          final youtubeUrl = 'https://youtu.be/$videoId';
                          _launchURL(youtubeUrl);
                        },
                      ),
                    );
                  } catch (e) {
                    debugPrint('Error al procesar video: $e');
                    return Container();
                  }
                }
                
                // Manejo de archivos
                if (element?.attributes['data-embedded'] == 'file') {
                  try {
                    final embedProps = element?.attributes['data-embedded-props'] ?? '';
                    final fileData = jsonDecode(embedProps)['fileData'];
                    print(fileData);
                    final fileName = fileData['filename'] as String;
                    final fileUrl = fileData['url'] as String;
                    final accessToken = fileData['access_token'] as String;
                    final idDoc = fileData['id'].toString();
                    final checksum = fileData['checksum'] as String;
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.file_download),
                        label: Text('Descargar $fileName'),
                        onPressed: () {
                          final fullUrl = '${baseUrl}web/content/$idDoc?access_token=$accessToken&filename=$fileName&unique=$checksum&download=true';
                          _launchURL(fullUrl);
                        },
                      ),
                    );
                  } catch (e) {
                    debugPrint('Error al procesar archivo: $e');
                    return Container();
                  }
                }
                
                return Container();
              },
            );
          },
        ),
      ],
    );
  }
}