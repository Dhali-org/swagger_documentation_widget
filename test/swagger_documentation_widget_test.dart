import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swagger_documentation_widget/swagger_documentation_widget.dart';

void main() {
  testWidgets('SwaggerDocumentationWidget test', (WidgetTester tester) async {
    // Define the parameters for the widget
    const jsonContent = '{"test": "data"}';
    const title = 'Some API Documentation';
    const docExpansion = DocExpansion.full;
    const deepLink = true;
    const syntaxHighlightTheme = SyntaxHighlightTheme.monokai;
    const persistAuthorization = true;

    // Build the SwaggerDocumentationWidget
    await tester.pumpWidget(
      MaterialApp(
        home: SwaggerDocumentationWidget(
          jsonContent: jsonContent,
          title: title,
          docExpansion: docExpansion,
          deepLink: deepLink,
          syntaxHighlightTheme: syntaxHighlightTheme,
          persistAuthorization: persistAuthorization,
        ),
      ),
    );

    final swaggerWidget = tester.widget(find.byType(SwaggerDocumentationWidget))
        as SwaggerDocumentationWidget;

    // Verify that SwaggerDocumentationWidget properties are correctly set
    expect(swaggerWidget.jsonContent, jsonContent);
    expect(swaggerWidget.title, title);
  });
}
