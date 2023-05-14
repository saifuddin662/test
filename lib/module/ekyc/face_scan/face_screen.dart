import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/ekyc/face_scan/preview_face.dart';
import 'package:red_cash_dfs_flutter/utils/extensions/extension_string.dart';
import '../../../base/base_consumer_state.dart';
import '../../../utils/Colors.dart';
import '../../../utils/dimens/dimensions.dart';
import '../camera_controller.dart';
import '../ekyc_core/base_camera_container.dart';
import '../ekyc_core/ekyc_constants.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 08,February,2023.

class FaceScreen extends ConsumerStatefulWidget {
  const FaceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FaceScreenState();
}

class _FaceScreenState extends BaseConsumerState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BaseCameraContainer(),
          Container(
            alignment: Alignment.center,
            child: Container(
              width: DimenSizes.dimen_310,
              height: DimenSizes.dimen_400,
              decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(DimenSizes.dimen_500)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: DimenSizes.dimen_30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CameraButton(
                    callback: () async {

                      final name = "${EKycConstants.tagFace}_${DateTime.now().millisecondsSinceEpoch.toString()}";
                      var path =  await ref.read(cameraControllerProvider.notifier).capturePhoto(name.replaceWhiteSpaceWith_());

                      try {
                        if(!mounted) return;
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            PreviewFace(
                                imagePath: path,
                            )
                        ));
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                    buttonStyle: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                        const CircleBorder(side: BorderSide.none),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(DimenSizes.dimen_20),
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CameraButton extends StatelessWidget {
  final VoidCallback callback;
  final Widget child;
  final ButtonStyle buttonStyle;

  const CameraButton({
    Key? key,
    required this.callback,
    required this.child,
    required this.buttonStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: ElevatedButton(
        onPressed: callback,
        style: buttonStyle,
        child: child,
      ),
    );
  }
}
