import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Webview(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class Webview extends StatefulWidget {
  const Webview({super.key});

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web View Example'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 800,
            width: 400,
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                  url: WebUri('https://elegant-tanuki-0787ed.netlify.app/')),
            ),
          ),
        ],
      ),
    );
  }
}
