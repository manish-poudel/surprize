import 'package:Surprize/CustomWidgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {

  String url;
  String heading;
  WebViewPage(this.heading,this.url);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple[800]),
      home: Scaffold(
        appBar: CustomAppBar(heading, context),
        body: WebView(
          key: UniqueKey(),
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: url,
        ),
      ),
    );
  }

}
