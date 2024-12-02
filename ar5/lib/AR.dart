import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AR extends StatefulWidget {
  const AR({super.key});

  @override
  State<AR> createState() => _ARState();
}

class _ARState extends State<AR> {
  ArCoreController? arCoreController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkArSupport();
  }

  Future<void> _checkArSupport() async {
    bool isArSupported = await ArCoreController.checkArCoreAvailability();
    if (!isArSupported) {
      _showError('AR is not supported on this device');
      return;
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  void onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onNodeTap = (name) => onNodeTapped(name);
    load3DModel();
  }

  void onNodeTapped(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Node $name was tapped'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> load3DModel() async {
    try {
      // Example direct URLs for 3D models:
      // 1. GLTF model: https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF/Duck.gltf
      // 2. GLB model: https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Binary/Duck.glb

      final node = ArCoreReferenceNode(
        name: 'duck_model',
        objectUrl:
            'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Binary/Duck.glb',
        position: vector.Vector3(0, -1, -2), // Adjust position as needed
        rotation: vector.Vector4(0, 180, 0, 0),
        scale: vector.Vector3(0.2, 0.2, 0.2), // Adjust scale as needed
      );

      await arCoreController?.addArCoreNode(node);
    } catch (e) {
      _showError('Failed to load 3D model: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AR View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: load3DModel,
          ),
        ],
      ),
      body: ArCoreView(
        onArCoreViewCreated: onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }
}
