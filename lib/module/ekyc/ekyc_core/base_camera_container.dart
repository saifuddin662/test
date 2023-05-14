import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../base/base_consumer_state.dart';
import '../camera_controller.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 08,February,2023.

class BaseCameraContainer extends ConsumerStatefulWidget {
  const BaseCameraContainer({Key? key}) : super(key: key);

  @override
  ConsumerState<BaseCameraContainer> createState() => _CameraContainerState();
}

class _CameraContainerState extends BaseConsumerState<BaseCameraContainer> {
  @override
  Widget build(BuildContext context) {
    log.info("build -> BaseCameraContainer");
    final state = ref.watch(cameraControllerProvider);
    final CameraController? controller = state.controller;

    final size = MediaQuery.of(context).size;

    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [CircularProgressIndicator()],
        ),
      );
    } else {
      var scale = size.aspectRatio * controller.value.aspectRatio;
      if (scale < 1) scale = 1 / scale;
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        child: Transform.scale(
          scale: scale,
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  child: CameraPreview(
                    ref.watch(cameraControllerProvider).controller!,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
