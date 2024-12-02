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
  ArCoreNode? currentNode;
  double currentAngle = 0.0;
  double _baseRotation = 0.0;
  double _dragX = 0.0;

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
    load3DModel();
  }

  Future<void> load3DModel() async {
    try {
      final material = ArCoreMaterial(
        color: Colors.white,
        metallic: 1.0,
        roughness: 0.5,
        reflectance: 1.0,
      );
      final node = ArCoreReferenceNode(
        name: 'custom_model',
        objectUrl:
            'https://github.com/VirangaWeerabandara/Flutter-AR-test/raw/refs/heads/main/ar5/assets/iron_man.glb',
        position: vector.Vector3(0, -1, -2),
        rotation: vector.Vector4(0, currentAngle, 0, 1),
        scale: vector.Vector3(0.5, 0.5, 0.5),
      );

      await arCoreController?.addArCoreNode(node);
      currentNode = node;
    } catch (e) {
      _showError('Failed to load 3D model: $e');
    }
  }

  void updateRotation() async {
    try {
      final node = ArCoreReferenceNode(
        name: 'custom_model',
        objectUrl:
            'https://github.com/VirangaWeerabandara/Flutter-AR-test/raw/refs/heads/main/ar5/assets/iron_man.glb',
        position: vector.Vector3(0, -1, -2),
        rotation: vector.Vector4(0, currentAngle, 0, 1),
        scale: vector.Vector3(0.5, 0.5, 0.5),
      );

      await arCoreController?.removeNode(nodeName: 'custom_model');
      await arCoreController?.addArCoreNode(node);
      currentNode = node;
    } catch (e) {
      _showError('Failed to rotate model: $e');
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
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _dragX += details.delta.dx * 0.5;
            currentAngle = _baseRotation + _dragX;
            updateRotation();
          });
        },
        onPanEnd: (_) {
          _baseRotation = currentAngle;
          _dragX = 0;
        },
        child: ArCoreView(
          onArCoreViewCreated: onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      ),
    );
  }
}
