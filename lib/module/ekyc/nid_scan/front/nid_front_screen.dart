import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_cash_dfs_flutter/module/ekyc/nid_scan/front/preview_nid_front.dart';
import 'package:red_cash_dfs_flutter/utils/extensions/extension_string.dart';
import '../../../../base/base_consumer_state.dart';
import '../../../../ui/custom_widgets/custom_common_text_widget.dart';
import '../../../../utils/Colors.dart';
import '../../../../utils/dimens/dimensions.dart';
import '../../../../utils/styles.dart';
import '../../camera_controller.dart';
import '../../ekyc_core/base_camera_container.dart';
import '../../ekyc_core/ekyc_constants.dart';

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 08,February,2023.

class NidFrontScreen extends ConsumerStatefulWidget {
  const NidFrontScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NidFrontScreenState();
}

class _NidFrontScreenState extends BaseConsumerState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BaseCameraContainer(),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 30,
            left: DimenSizes.dimen_0,
            right: DimenSizes.dimen_30,
            bottom: DimenSizes.dimen_0,
            child:  RotatedBox(
                quarterTurns: 1,
                child: CustomCommonTextWidget(
                text: "top".tr(),
                style: CommonTextStyle.regular_20,
                color: bottomNavBarBackgroundColor,
                shouldShowMultipleLine : true
            ),),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 40,
            left: DimenSizes.dimen_0,
            right: MediaQuery.of(context).size.width - 50,
            bottom: DimenSizes.dimen_0,
            child: RotatedBox(
                quarterTurns: 1,
                child: CustomCommonTextWidget(
                text: "bottom".tr(),
                style: CommonTextStyle.regular_20,
                color: bottomNavBarBackgroundColor,
                shouldShowMultipleLine : true
            ),),
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              width: DimenSizes.dimen_350,
              height: DimenSizes.dimen_600,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(DimenSizes.dimen_20)),
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
                      final name =
                          "${EKycConstants.tagNidFront}_${DateTime.now().millisecondsSinceEpoch.toString()}";
                      var path = await ref
                          .read(cameraControllerProvider.notifier)
                          .capturePhoto(name.replaceWhiteSpaceWith_());
                      //log.info("path----------------------------> $path");

                      try {
                        if (!mounted) return;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviewNidFront(
                                      imagePath: path,
                                    )));
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
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Icon(Icons.camera_alt_outlined),
                          ),
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
