import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ARModelPage(),
    );
  }
}

class ARModelPage extends StatefulWidget {
  const ARModelPage({Key? key}) : super(key: key);

  @override
  _ARModelPageState createState() => _ARModelPageState();
}

class _ARModelPageState extends State<ARModelPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optional: show loading indicator
          },
        ),
      )
      ..loadRequest(Uri.parse('https://elegant-tanuki-0787ed.netlify.app/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR Model Viewer')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
