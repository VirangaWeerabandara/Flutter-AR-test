import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  runApp(MyARApp());
}

class MyARApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ARModelViewer(),
    );
  }
}

class ARModelViewer extends StatefulWidget {
  @override
  _ARModelViewerState createState() => _ARModelViewerState();
}

class _ARModelViewerState extends State<ARModelViewer> {
  late ArCoreController arCoreController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Model Viewer'),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = _handleOnNodeTap;
    _addModel();
  }

  void _addModel() {
    final modelNode = ArCoreReferenceNode(
      name: 'my_3d_model',
      // Replace with your actual asset path
      object3DFileName: 'assets/spider_man.glb',
      scale: Vector3(0.5, 0.5, 0.5), // Adjust scale as needed
      position: Vector3(0, 0, 0), // Initial position
      rotation: Vector4(0, 0, 0, 0),
    );

    arCoreController.addArCoreNodeWithAnchor(modelNode);
  }

  void _handleOnNodeTap(String nodeName) {
    // Handle node tap events if needed
    print('Tapped on node: $nodeName');
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
