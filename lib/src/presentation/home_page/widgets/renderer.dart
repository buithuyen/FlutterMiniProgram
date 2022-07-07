import 'package:flutter/widgets.dart';
import 'package:mini_app/src/platform/miniapps/message_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

class Renderer extends StatefulWidget {
  const Renderer({Key? key}) : super(key: key);

  @override
  _RenderedViewState createState() => _RenderedViewState();
}

class _RenderedViewState extends State<Renderer> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    _loadHtmlFromAssets();

    return WebView(
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      javascriptChannels: <JavascriptChannel>{
        logicMessageHandler(context, _controller),
      },
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/miniapp/index.html');

    _controller.future.then((controller) {
      controller.loadUrl(Uri.dataFromString(fileText,
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString());
    });
  }
}
