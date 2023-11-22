import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swagger_documentation_widget/swagger_documentation_widget.dart'; // Correct path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> loadJson() async {
    final s = await rootBundle.loadString('example-openapi-spec.json');
    print("JSON: $s");
    return await rootBundle.loadString('example-openapi-spec.json');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swagger Documentation Test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Swagger Documentation'),
        ),
        body: FutureBuilder<String>(
          future: loadJson(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SwaggerDocumentationWidget(
                jsonContent: snapshot.data ?? '',
                title: 'API Documentation',
                docExpansion: DocExpansion.full,
                deepLink: true,
                displayOperationId: true,
                filter: true,
                showExtensions: true,
                showCommonExtensions: true,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
