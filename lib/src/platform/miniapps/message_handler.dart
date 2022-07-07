import 'package:flutter/material.dart';
import 'package:mini_app/src/packages/liquidcore/liquidcore.dart';
import 'package:mini_app/src/platform/miniapps/jsbridge.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';

JavascriptChannel logicMessageHandler(
    BuildContext context, Completer<WebViewController> controller) {
  return JavascriptChannel(
      name: 'SUPA',
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        switch (message.message) {
          case 'onMyFunc':
            {
              JSContext? jsContext;
              String jsContextResponse = '<empty>';

              jsContextResponse =
                  await _executeJavascriptEngine(jsContext, 'onMyFunc');
              print('Response from isolated js code was: $jsContextResponse');

              controller.future.then((webviewController) {
                webviewController.runJavascriptReturningResult(
                    'document._observer.notify("$jsContextResponse")');
              });
            }
            break;

          case 'phoneCall':
            {
              launchCaller();
            }
            break;

          default:
            {
              // do nothing
            }
            break;
        }
      });
}

Future<String> _executeJavascriptEngine(
    JSContext? context, String funcName) async {
  String response = '<empty>';

  try {
    context ??= JSContext();

    String pageCode = await rootBundle.loadString('assets/miniapp/index.js');

    response = await context.evaluateScript("""
    (function(){ 
      var _page = {};
      var Page = function(params){
        _page = params;
      }; 
      $pageCode 
      return _page.$funcName(); 
    })();
    """);
  } catch (e) {
    print('Got script exception: $e');
  }

  return response;
}
