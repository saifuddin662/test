import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import 'ekyc_core/cam_direction_provider.dart';
import 'ekyc_core/camera_direction_type.dart';
import 'ekyc_core/camera_state.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 08,February,2023.

class CameraStateController extends StateNotifier<CameraState>
    with WidgetsBindingObserver {
  Logger get log => Logger(runtimeType.toString());
  CameraDescription? _camera;
  final Ref ref;

  CameraStateController(this.ref) : super(const CameraState()) {
    log.info("CameraStateController -> _setupCamera");
    _setupCamera().then((_) => WidgetsBinding.instance.addObserver(this));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    state.controller?.dispose();
    super.dispose();
  }

  @override
  //ignore: avoid_renaming_method_parameters
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    super.didChangeAppLifecycleState(appState);
    if (state.controller == null ||
        state.controller?.value.isInitialized != true) {
      log.info("controller null ||  value !isInitialized");
      return;
    }
    if ([AppLifecycleState.inactive, AppLifecycleState.paused]
        .contains(appState)) {
      state.controller?.dispose();
      log.info("controller disposed");
    } else if (appState == AppLifecycleState.resumed) {
      log.info("didChangeAppLifecycleState -> _setupCamera");
      _setupCamera();
    }
  }

  Future<void> _setupCamera() async {
    log.info("in _setupCamera");
    final CamDirection direction = ref.watch(camDirectionProvider);

    if (direction.name == CamDirection.front.name) {
      _camera = (await availableCameras()).firstWhereOrNull(
              (instance) => instance.lensDirection == CameraLensDirection.front);
    } else if (direction.name == CamDirection.back.name) {
      _camera = (await availableCameras()).firstWhereOrNull(
              (instance) => instance.lensDirection == CameraLensDirection.back);
    }

    if (_camera == null) {
      log.info("couldNotLoadCamera");
      return;
    }
    await state.controller?.dispose();

    final controller = CameraController(_camera!, ResolutionPreset.high, enableAudio: false);
    try {
      await controller.initialize();
    } on CameraException {
      log.info("pleaseGrantCameraPermission");
    }
    state = state.copyWith(controller: controller);
    log.info("add new controller");
  }

  void clearPicture() {
    final newState = state.copyWith(file: null);
    state = newState;
  }

  Future<String> capturePhoto(String name) async {
    XFile? xfile;
    try {
      xfile = await state.controller!.takePicture();
      state = state.copyWith(file: xfile);

      String tempFilePath = '${(await getTemporaryDirectory()).path}/$name.jpg';

      await xfile.saveTo(tempFilePath);

      return tempFilePath;
    } catch (e, stacktrace) {
      log.info("couldNotTakePicture");
      return "";
    }
  }

  Future<void> switchCamera() async {
    if (state.controller?.description.lensDirection ==
        CameraLensDirection.back) {
      ref
          .watch(camDirectionProvider.notifier)
          .updateDirection(CamDirection.front);

      _setupCamera();
    } else {
      ref
          .watch(camDirectionProvider.notifier)
          .updateDirection(CamDirection.back);
      _setupCamera();
    }
  }
}

final cameraControllerProvider =
    StateNotifierProvider<CameraStateController, CameraState>((ref) {
  return CameraStateController(ref);
});
