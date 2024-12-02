import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final node = ArCoreReferenceNode(
        name: 'model',
        objectUrl:
            'https://drive.google.com/file/d/1VvVpDdveK7ya4Pu2xrkvJVEqVWIYk2fF/view?usp=sharing',
        position: vector.Vector3(0, 0, -1),
        rotation: vector.Vector4(0, 180, 0, 0),
        scale: vector.Vector3(0.5, 0.5, 0.5),
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
        title: const Text('AR Viewer'),
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
        enableUpdateListener: true,
      ),
    );
  }
}
