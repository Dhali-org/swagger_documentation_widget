library swagger_documentation_widget;

import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Controls the default expansion setting for the operations and tags.
enum DocExpansion {
  /// expands only the tags
  list,

  /// expands the tags and operations
  full,

  /// expands nothing
  none,
}

enum SyntaxHighlightTheme {
  agate('agate'),
  arta('arta'),
  monokai('monokai'),
  nord('nord'),
  obsidian('obsidian'),
  tomorrowNight('tomorrow-night');

  final String theme;
  const SyntaxHighlightTheme(this.theme);
}

class SwaggerDocumentationWidget extends StatefulWidget {
  ///Schema path (YAML/JSON).
  final String jsonContent;

  ///Defines the title that is visible in the browser tab.
  final String title;

  /// Controls the default expansion setting for the operations and tags.
  final DocExpansion docExpansion;

  ///(Default false) enables the use of deep-links to reference each node in the url (ex: /swagger/#/post).
  final bool deepLink;

  /// Highlight.js syntax coloring theme to use. (Only these 6 styles are available).
  final SyntaxHighlightTheme syntaxHighlightTheme;

  /// If set to true, it persists authorization data and it would not be lost on browser close/refresh
  final bool persistAuthorization;

  /// Controls the display of operationId in operations list
  final bool displayOperationId;

  /// If set, enables filtering. The top bar will show an edit box that
  /// you can use to filter the tagged operations that are shown.
  /// Filtering is case sensitive matching the filter expression anywhere
  /// inside the tag.
  final bool filter;

  /// Controls the display of vendor extension (x-) fields and values for Operations, Parameters, Responses, and Schema.
  final bool showExtensions;

  /// Controls the display of extensions (`pattern`, `maxLength`,
  /// `minLength`, `maximum`, `minimum`) fields and values for Parameters.
  final bool showCommonExtensions;

  const SwaggerDocumentationWidget({
    super.key,
    required this.jsonContent,
    required this.title,
    this.docExpansion = DocExpansion.list,
    this.syntaxHighlightTheme = SyntaxHighlightTheme.agate,
    this.deepLink = false,
    this.persistAuthorization = false,
    this.displayOperationId = false,
    this.filter = false,
    this.showExtensions = false,
    this.showCommonExtensions = false,
  });

  @override
  State<SwaggerDocumentationWidget> createState() =>
      _SwaggerDocumentationState();
}

class _SwaggerDocumentationState extends State<SwaggerDocumentationWidget> {
  final String viewType = 'iframeElement';
  static bool viewTypeIsRegistered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final htmlContent = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta
    name="description"
    content="SwaggerUI"
  />
  <title>${widget.title}</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5.3.0/swagger-ui.css" />

  <style>
    .try-out,
    .btn.try-out__btn {
      display: none !important;
    }
  </style>

</head>
<body>
<body>
  <div id="swagger-ui"></div>
  <script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-bundle.js" crossorigin></script>
  <script>
    var openApiSpec = ${widget.jsonContent};
    window.onload = () => {
      window.ui = SwaggerUIBundle({
        dom_id: '#swagger-ui',
        spec: openApiSpec,
        docExpansion: '${widget.docExpansion.name}',
        deepLinking: ${widget.deepLink},
        spec: openApiSpec,
        syntaxHighlight: {
          activate: true,
          theme: '${widget.syntaxHighlightTheme.theme}',
        },
        persistAuthorization: ${widget.persistAuthorization},
        displayOperationId: ${widget.displayOperationId},
        fliter: ${widget.filter},
        showExtensions: ${widget.showExtensions},
        showCommonExtensions: ${widget.showCommonExtensions},
      });
    };
  </script>
</body>
</html>
''';

    // Make sure to call registerViewFactory only once
    if (!viewTypeIsRegistered) {
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        final iframe = html.IFrameElement()
          ..src =
              'data:text/html;charset=utf-8,${Uri.encodeComponent(htmlContent)}'
          ..style.border = 'none';

        return iframe;
      });
      viewTypeIsRegistered = true;
    }

    return HtmlElementView(viewType: viewType);
  }
}
